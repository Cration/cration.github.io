---
layout: post
title: "_chkstk函数浅析"
description: "　　简要分析了windows中_chkstk函数的工作原理和使用场景。"
category: "program"
tags: [驱动开发, 编程技巧, C]
---
{% include JB/setup %}

　　博文“[x264内核移植](http://cration.rcstech.org/program/2014/01/06/x264-migrate-to-kernel/)”中提到关于函数chkstk_ms的用法，在此对其进行一些探讨和分析。

　　chkstk_ms是mingw中的函数名，在Windows下有相同功能的函数：_chkstk。[MSDN对函数_chkstk的解释](http://msdn.microsoft.com/en-us/library/ms648426(v=vs.85).aspx)非常简洁：

>    Called by the compiler when you have more than one page of local variables in your function.
>
>    _chkstk Routine is a helper routine for the C compiler. For x86 compilers, _chkstk Routine is called when the local variables exceed 4K bytes; for x64 compilers it is 8K.

　　当局部变量超过4K（x86）或8K（x64）时，编译器会自动在函数入口添加对_chkstk的调用。下面分析原因。

　　Windows在创建用户栈时，会做如下操作：

* 分配栈空间所需的虚拟内存，大小为Stack Reserve Size。

* 根据Stack Commit Size锁定内存页面，如果Stack Commit Size小于Stack Reverve Size，那么要增加一个page，这个额外申请的page用作guard page。

* 将栈底部的page设定为guard page。

　　那么，当分配的栈空间被用尽后，会访问到guard page，从而导致page fault。Page fault的处理函数MmAccessFault()可以分析出此次page fault是guard page导致，变会默认有用户栈处理程序MiCheckForUserStackOverflow()来处理。如果栈没有溢出，即Stack Commit Size小于Stack Reserve Size，MiCheckForUserStackOverflow()会自动扩展栈空间，扩展大小为一个GUARD_PAGE_SIZE。而GUARD_PAGE_SIZE对于x86和x64定义如下：

{% highlight C %}
#define GUARD_PAGE_SIZE (PAGE_SIZE * 2)     //x64
#define GUARD_PAGE_SIZE PAGE_SIZE           //x86
{% endhighlight %}

　　上面提到了Windows用户栈的一些特性，但是还没说明_chkstk的用途。想象这样的情况：当分配的栈空间被用尽后，一次性访问到超过一个guard page范围的空间，那么也会导致page fault，但是此时page fault处理程序不能识别此次page fault的原因，不能做出正确的处理。因此，在堆栈生长的时候，我们需要保证程序访问的地址不超过当前guard page，而_chkstk函数就是实现这个目的。来看一下 _chkstk的代码：

{% highlight asm %}
___chkstk       proc near                    ; CODE XREF: _main+2Ap
                push    ecx                  ; 保存ecx的值
                mov     ecx, esp             ; 把chkstk函数栈顶地址给ecx，为后面的分配做准备
                add     ecx, 8               ; 找到未调用函数前的栈顶 chkstk函数调用前压入一个返回地址+push的ecx=8
probe:                                       ; CODE XREF: ___chkstk+1Bj
                cmp     eax, 1000h           ; 比较 eax 跟 4K（系统默认内存页大小）
                jb      short done           ; 如果需要的不到一个页就跳到 done 处
                sub     ecx, 1000h           ; ecx 地址减去4096 也就是准备分配4K内存页
                or      dword ptr [ecx], 0   ; 系统进行实际分配内存
                                             ; 这个时候之前只不过是分配虚存，内存没有 commit ,
                                             ; 这个时候对这个内存地址进行读写操作都会引发一个 page fault 异常
                                             ; (_XCPT_GUARD_PAGE_VIOLATION), OS捕获这个异常,检查一定的条件,
                                             ; 适合的时候就把这个内存页 commit 了，即分配了实际的物理内存
                sub     eax, 1000h           ; 将eax的值减去已经分配的4K内存
                jmp     short probe          ; 调回继续判断是否还需要一个页内存
; ---------------------------------------------------------------------------

done:                                        ; CODE XREF: ___chkstk+Bj
                sub     ecx, eax             ; 求得还需要的空间（堆栈负增长 高地址代表的空间较小）
                or      dword ptr [ecx], 0   ; 系统进行实际分配内存
                mov     eax, esp             ; 把当年函数的esp赋给eax，为恢复ecx作准备 esp处放的是原始的ecx
                mov     esp, ecx             ; 把分配好的顶部地址赋给esp
                mov     ecx, [eax]           ; 恢复ecx的值（eax=chkstk函数的exp，exp地址处存放的是前面push的ecx）
                mov     eax, [eax+4]         ; 找到返回地址 chkstk+4地址就是函数调用前压入的返回地址
                jmp     eax                  ; 返回到执行chkstk函数之前的地址继续执行
{% endhighlight %}

　　上面提到，当局部变量超过一定的大小时，编译器会自动加入_chkstk，而_chkstk的唯一一个参数是通过eax传递的，值是当前所需要增加的栈的大小（一般等于局部变量占用空间大小）。在_chkstk函数中不断将eax和ecx减去4K，并通过一个“无意义”的or操作访问内存，从而使操作系统分配新的内存页；最终，该函数执行完毕后，esp和堆栈大小都不是原来的值了，而是为局部变量分配空间之后的值了。总体来说，_chkstk函数的作用是保证栈的连续生长。

　　在内核态中，_chkstk的实现只是一个空函数而已，原因是内核中的栈大小是固定的，x86上只有12K，x64上是24K。原因是内核中的地址空间是全局共享的，若每个线程的栈空间太大，将占用大量的内核地址。所以在内核开发时，应尽量避免递归或大量局部空间的申请。

###References

[_chkstk Routine](http://msdn.microsoft.com/en-us/library/ms648426(v=vs.85).aspx)  
[从_chkstk说起，谈谈用户栈的管理](http://blog.dynox.cn/?p=1044)  
[堆栈分配检测函数chkstk执行过程分析](http://bbs.pediy.com/showthread.php?t=147689)
