---
layout: post
title: "堆栈平衡与对齐"
tags: [asm, 理解计算机]
---
{% include JB/setup %}

#调用约定
　　C语言的种种调用约定中，以__cdecl最为常见，本小节以__cdecl约定为切入点，剖析计算机在函数调用过程的细节，主要分析堆栈的状态变化。

　　调用过程主要分以下几个阶段<sup>[【1】](#【1】)</sup>：
###参数压栈
　　自右向左将参数逐一压栈。在编译过程中，编译器会根据压栈参数所占用的空间大小，生成相应的代码，用于函数返回时释放这段空间。释放空间的本质只是将esp指针加上释放的长度，并不对释放的空间做清空处理。
###函数调用
　　在本阶段，处理器将执行 `call` 指令，具体操作是：将指令寄存器eip压栈，并跳转到被调用函数的起始地址。相当于连续执行了 `push` 和 `jmp` 指令。
###处理ebp寄存器
　　ebp作为基址指针寄存器（base pointer<sup>[【2】](#【2】)</sup>），最常见的应用场景便是通过对ebp附加偏移来访问堆栈中的变量。对于一个特定的函数而言，ebp通常是不变的。这一阶段常见的操作是：
{% highlight asm %}
    push ebp
    mov ebp, esp
{% endhighlight %}
###分配局部变量空间
　　局部变量存在于堆栈中，这也是为何局部变量的访问往往比全局变量更快的原因。为局部变量分配空间的操作很简单：
{% highlight asm %}
    sub esp, #      ;'#'号表示一个立即数，是局部变量占用总空间的大小
{% endhighlight %}
###保护寄存器状态
　　由于x86架构的CPU只有8个通用寄存器，对于函数间的切调用操作，需要将原先的寄存器状态保存起来，以免调用结束后，调用者的运行异常。通常是几个push指令。

###执行函数
　　在此过程中，代码所访问到的局部变量和函数参数都是通过ebp的偏移进行寻址。如，第一个局部变量的地址是(ebp - 4)，第一个参数的地址是(ebp + 8)。而函数的返回地址则保存在(ebp + 4)中。

###恢复寄存器状态
　　函数功能执行完毕后，准备返回，此时可以将之前保存的寄存器值恢复到对应的寄存器中。一般通过pop指令实现。

###释放局部变量空间
　　函数功能执行完毕后，需要释放局部变量的空间，以保持堆栈平衡。与分配局部变量空间类似，通常只是将esp寄存器加上一个值：
{% highlight asm %}
    add esp, #
{% endhighlight %}

###处理ebp寄存器
　　对应的，要恢复调用者的ebp值，执行操作：
{% highlight asm %}
    pop ebp
{% endhighlight %}
###函数返回
　　这是子函数的最后一步操作，执行`ret`指令，将eip寄存器从栈中弹出，并跳转到eip指向的地址。若函数有返回值，一般会存放在eax寄存器中。
###释放参数空间
　　对于__cdecl约定而言，释放参数空间的任务是由调用者来执行的。调用者将栈中的参数pop到无关紧要的寄存器中，或者，更常见的是直接将esp寄存器加上参数占用的总空间大小，类似于子函数清空局部变量空间。
#堆栈对齐
　　不久前在做一个RGB->YUV的SSE优化，得知SSE的许多指令都要求访问的内存地址是16字节对齐的。对于全局变量而言，我们可以轻易地利用 `#pragma pack(n)` 或者 `__attribute__(aligned(n))` 告知编译器进行对齐。但对于在堆栈中的变量而言，编译器不可能得知运行时堆栈指针的状态，所以也就无法在编译时进行对齐。

　　思路1：进入函数后，将ebp寄存器对齐到16字节，然后再分配局部变量空间。

　　分析：如果这么做，那局部变量将可以通过ebp的偏移来访问，并且是16字节对齐，但在函数执行之前入栈的参数就无法正确访问了，因为编译器默认(ebp + 8)是第一个参数。如此看来，在函数内部进行处理似乎不太容易实现栈对齐。那么，如果在函数外部做一些处理呢？我们来看看开源编码器[x264](http://www.videolan.org/developers/x264.html)是怎么做的：
{% highlight asm %}
;-----------------------------------------------------------------------------
; void stack_align( void (*func)(void*), void *arg );
;-----------------------------------------------------------------------------
cglobal stack_align
    push ebp
    mov  ebp, esp
    sub  esp, 12
    and  esp, ~15
    mov  ecx, [ebp+8]
    mov  edx, [ebp+12]
    mov  [esp], edx
    mov  edx, [ebp+16]
    mov  [esp+4], edx
    mov  edx, [ebp+20]
    mov  [esp+8], edx
    call ecx
    leave
    ret
{% endhighlight %}

（未完待续）

##参考
<span id="【1】"></span>【1】 [http://www.unixwiz.net/techtips/win32-callconv-asm.html](http://www.unixwiz.net/techtips/win32-callconv-asm.html)
<span id="【2】"></span>【2】 [http://www.swansontec.com/sregisters.html](http://www.swansontec.com/sregisters.html)
