---
layout: post
title: "μC/OS-Ⅱ移植之FPU堆栈平衡"
description: "　　记录了一次关于STM32F407的FPU调试经历，并给出了μC/OS-Ⅱ在开启FPU的情况下的移植方式。"
category: "Embedded"
tags: [μC/OS-Ⅱ, FPU, ARM, asm, 嵌入式, C]
---
{% include JB/setup %}

　　2014年03月28日，帮胖子调试毕设的程序，现象是：执行一个STM32的数学库函数（CFFT）后，进入hardfault_handler。以下描述调试流程。

　　①首先猜测，hardfault多半是非法指针导致的，检查了参数的值，发现并无异常。  
　　②单步跟踪进出错的函数，发现函数体执行时没有出错，函数返回时，进入hardfault。更细粒度的跟踪时发现，在函数体内执行运算时，函数返回值保存的位置被修改，导致返回时错误。  
　　③再次跟踪并观察参数、变量、寄存器的值，发现栈顶指针SP(R13)进入一个全局static数组内部，而这个全局数组正是该函数的参数之一，在执行函数体时，修改了数组内容，从而导致函数返回地址被修改。　进一步观察，发现作为该任务堆栈的数组，和作为函数参数的数组，在地址上是紧邻的（都是全局static数组，编译器在分配地址空间时自然将其紧邻放置）。而在进入任务函数后，发现栈顶指针SP反向溢出了。如下图所示：

![内存示意图]({{site.img_path}}/STM32_UCOS_FPU_STACK.png)

　　④进一步跟踪，试图找出SP是在哪一步反向溢出的。但是由于μC/OS-Ⅱ任务调度比较复杂，这一步不是很顺利。最终利用内存断点找到了任务堆栈反向溢出的位置，在文件os_cpu_a.asm的OS_CPU_PendSVHandler函数的最后一条语句：BX LR。执行BX LR之前，栈顶指针的值都是符合期望的，但执行BX LR后，PC指针切到任务函数头部执行，此时发现SP指针反向溢出了。

{% highlight asm %}
OS_CPU_PendSVHandler
    CPSID   I                    ; Prevent interruption during context switch
    MRS     R0, PSP              ; PSP is process stack pointer
    CBZ     R0, OS_CPU_PendSVHandler_nosave      ; Skip register save the first time

    SUBS    R0, R0, #0x20        ; Save remaining regs r4-11 on process stack
    STM     R0, {R4-R11}

    LDR     R1, =OSTCBCur        ; OSTCBCur->OSTCBStkPtr = SP;
    LDR     R1, [R1]
    STR     R0, [R1]             ; R0 is SP of process being switched out

                                 ; At this point, entire context of process has been saved
OS_CPU_PendSVHandler_nosave
    PUSH    {R14}                ; Save LR exc_return value
    LDR     R0, =OSTaskSwHook    ; OSTaskSwHook();
    BLX     R0
    POP     {R14}

    LDR     R0, =OSPrioCur       ; OSPrioCur   = OSPrioHighRdy;
    LDR     R1, =OSPrioHighRdy
    LDRB    R2, [R1]
    STRB    R2, [R0]

    LDR     R0, =OSTCBCur        ; OSTCBCur = OSTCBHighRdy;
    LDR     R1, =OSTCBHighRdy
    LDR     R2, [R1]
    STR     R2, [R0]

    LDR     R0, [R2]             ; R0 is new process SP; SP = OSTCBHighRdy->StkPtr;
    LDM     R0, {R4-R11}         ; Restore r4-11 from new process stack
    ADDS    R0, R0, #0x20
    MSR     PSP, R0              ; Load PSP with new process SP
    ORR     LR, LR, #0x04        ; Ensure exception return uses process stack
    CPSIE   I
    BX      LR                   ; Exception return will restore remaining context

    END
{% endhighlight %}

　　⑤查阅手册得知，BX LR指令，在LR寄存器的高16位为0xFFFF时，表示异常返回，返回方式与LR的取值有关。观察LR寄存器，发现其值为0xFFFFFFED，这种情况下，返回时出栈的栈帧大小为26个words（一个word为32位），不开启FPU的情况下是8个words。

![BX LR返回方式]({{site.img_path}}/STM32_UCOS_FPU_STACK2.png)

![异常返回栈帧]({{site.img_path}}/STM32_UCOS_FPU_STACK3.png)

　　到此，问题基本上浮出水面了。在任务创建时，μC/OS-Ⅱ“伪造”了一个进入异常的环境，但是在构建环境时没有将FPU相关的寄存器入栈；而在任务调度时，模拟异常返回的情况，却试图在栈中取出FPU相关的寄存器的值，因此导致了栈反向溢出。　任务创建时的堆栈操作代码如下：

{% highlight C %}
OS_STK *OSTaskStkInit (void (*task)(void *p_arg), void *p_arg, OS_STK *ptos, INT16U opt)
{
    OS_STK *stk;


    (void)opt;          /* 'opt' is not used, prevent warning                 */
    stk       = ptos;   /* Load stack pointer                                 */

                        /* Registers stacked as if auto-saved on exception    */
    *(stk)    = (INT32U)0x01000000uL;      // xPSR
    *(--stk)  = (INT32U)task;              // Entry Point
    *(--stk)  = (INT32U)OS_TaskReturn;     // R14 (LR)
    *(--stk)  = (INT32U)0x12121212uL;      // R12
    *(--stk)  = (INT32U)0x03030303uL;      // R3
    *(--stk)  = (INT32U)0x02020202uL;      // R2
    *(--stk)  = (INT32U)0x01010101uL;      // R1
    *(--stk)  = (INT32U)p_arg;             // R0 : argument

                                           // Remaining registers saved on process stack
    *(--stk)  = (INT32U)0x11111111uL;      // R11
    *(--stk)  = (INT32U)0x10101010uL;      // R10
    *(--stk)  = (INT32U)0x09090909uL;      // R9
    *(--stk)  = (INT32U)0x08080808uL;      // R8
    *(--stk)  = (INT32U)0x07070707uL;      // R7
    *(--stk)  = (INT32U)0x06060606uL;      // R6
    *(--stk)  = (INT32U)0x05050505uL;      // R5
    *(--stk)  = (INT32U)0x04040404uL;      // R4

    return (stk);
}
{% endhighlight %}

　　找到问题后，只需要在创建任务和异常返回时加上FPU寄存器的保护与恢复即可。分别修改函数OSTaskStkInit与OS_CPU_PendSVHandler如下：

{% highlight C %}
OS_STK *OSTaskStkInit (void (*task)(void *p_arg), void *p_arg, OS_STK *ptos, INT16U opt)
{
    int i = 0;
    OS_STK *stk;
    (void)opt;          /* 'opt' is not used, prevent warning                 */

#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)

    stk       = ptos;   /* Load stack pointer                                 */

                        /* Registers stacked as if auto-saved on exception    */

    *(stk)    = (INT32U)0x00000000uL;
    *(--stk)  = (INT32U)0x00000000uL;

    for (i = 0; i < 16; ++i)
    {
        *(--stk) = (INT32U)(0x00000000uL);
    }

    *(--stk)  = (INT32U)0x01000000uL;      // xPSR
    *(--stk)  = (INT32U)task;              // Entry Point
    *(--stk)  = (INT32U)OS_TaskReturn;     // R14 (LR)
    *(--stk)  = (INT32U)0x12121212uL;      // R12
    *(--stk)  = (INT32U)0x03030303uL;      // R3
    *(--stk)  = (INT32U)0x02020202uL;      // R2
    *(--stk)  = (INT32U)0x01010101uL;      // R1
    *(--stk)  = (INT32U)p_arg;             // R0 : argument

                                           // Remaining registers saved on process stack
    *(--stk)  = (INT32U)0x11111111uL;      // R11
    *(--stk)  = (INT32U)0x10101010uL;      // R10
    *(--stk)  = (INT32U)0x09090909uL;      // R9
    *(--stk)  = (INT32U)0x08080808uL;      // R8
    *(--stk)  = (INT32U)0x07070707uL;      // R7
    *(--stk)  = (INT32U)0x06060606uL;      // R6
    *(--stk)  = (INT32U)0x05050505uL;      // R5
    *(--stk)  = (INT32U)0x04040404uL;      // R4

    for (i = 0; i < 16; ++i)
    {
        *(--stk) = (INT32U)(0x00000000uL);
    }

#else

    stk       = ptos;   /* Load stack pointer                                 */

                        /* Registers stacked as if auto-saved on exception    */
    *(stk)    = (INT32U)0x01000000uL;      // xPSR
    *(--stk)  = (INT32U)task;              // Entry Point
    *(--stk)  = (INT32U)OS_TaskReturn;     // R14 (LR)
    *(--stk)  = (INT32U)0x12121212uL;      // R12
    *(--stk)  = (INT32U)0x03030303uL;      // R3
    *(--stk)  = (INT32U)0x02020202uL;      // R2
    *(--stk)  = (INT32U)0x01010101uL;      // R1
    *(--stk)  = (INT32U)p_arg;             // R0 : argument

                                           // Remaining registers saved on process stack
    *(--stk)  = (INT32U)0x11111111uL;      // R11
    *(--stk)  = (INT32U)0x10101010uL;      // R10
    *(--stk)  = (INT32U)0x09090909uL;      // R9
    *(--stk)  = (INT32U)0x08080808uL;      // R8
    *(--stk)  = (INT32U)0x07070707uL;      // R7
    *(--stk)  = (INT32U)0x06060606uL;      // R6
    *(--stk)  = (INT32U)0x05050505uL;      // R5
    *(--stk)  = (INT32U)0x04040404uL;      // R4

#endif

    return (stk);
}
{% endhighlight %}

{% highlight asm %}
OS_CPU_PendSVHandler
    CPSID   I                    ; Prevent interruption during context switch
    MRS     R0, PSP              ; PSP is process stack pointer
    CBZ     R0, OS_CPU_PendSVHandler_nosave      ; Skip register save the first time

    SUBS    R0, R0, #0x20        ; Save remaining regs r4-11 on process stack
    STM     R0, {R4-R11}

#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
    SUB     R0, R0, #0x40
    VSTM    R0, {D8-D15}
#endif

    LDR     R1, =OSTCBCur        ; OSTCBCur->OSTCBStkPtr = SP;
    LDR     R1, [R1]
    STR     R0, [R1]             ; R0 is SP of process being switched out

                                 ; At this point, entire context of process has been saved
OS_CPU_PendSVHandler_nosave
    PUSH    {R14}                ; Save LR exc_return value
    LDR     R0, =OSTaskSwHook    ; OSTaskSwHook();
    BLX     R0
    POP     {R14}

    LDR     R0, =OSPrioCur       ; OSPrioCur   = OSPrioHighRdy;
    LDR     R1, =OSPrioHighRdy
    LDRB    R2, [R1]
    STRB    R2, [R0]

    LDR     R0, =OSTCBCur        ; OSTCBCur = OSTCBHighRdy;
    LDR     R1, =OSTCBHighRdy
    LDR     R2, [R1]
    STR     R2, [R0]

    LDR     R0, [R2]             ; R0 is new process SP; SP = OSTCBHighRdy->StkPtr;
    
#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
    VLDM    R0, {D8-D15}
    ADD     R0, R0, #0x40
#endif

    LDM     R0, {R4-R11}         ; Restore r4-11 from new process stack
    ADDS    R0, R0, #0x20

#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
    BIC.W   LR, LR, #0x10
#endif

    MSR     PSP, R0              ; Load PSP with new process SP
    ORR     LR, LR, #0x04        ; Ensure exception return uses process stack
    CPSIE   I
    BX      LR                   ; Exception return will restore remaining context

    END
{% endhighlight %}

-------------------------------------------

###References

[Making the best use of the available breakpoints](http://www.iar.com/Global/Resources/Developers_Toolbox/Building_and_debugging/Making_the_best_use_of_the_available_breakpoints.pdf)  
[M4在IAR环境下移植ucosii问题](http://www.deyisupport.com/question_answer/microcontrollers/stellaris_arm/f/57/t/8798.aspx)  
[Cortex-M4 Device Generic User Guide: Exception entry and return](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0553a/Babefdjc.html)  
[移植ucos2 到 STMF4 支持浮点,一点心得](http://www.amobbs.com/thread-5400648-1-1.html)  
[The Deﬁnitive Guide to ARM Cortex-M3 and Cortex-M4 Processors](ftp://ftp.cs.sjtu.edu.cn:990/hongzi/embedded%20systems/referece%20books/The.Definitive.Guide.to.the.ARM.Cortex.M3.Aug.2007.pdf)
