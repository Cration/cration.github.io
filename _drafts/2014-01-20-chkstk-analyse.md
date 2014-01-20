---
layout: post
title: "chkstk函数简析"
description: "　　简要分析了chkstk函数的工作原理和使用场景。"
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
*分配栈空间所需的虚拟内存，大小为Stack Reserve Size。
*根据Stack Commit Size锁定内存页面，如果Stack Commit Size小于Stack Reverve Size，那么要增加一个page，这个额外申请的page用作guard page。
*将栈底部的page设定为guard page。

　　那么，当分配的栈空间被用尽后，会访问到guard page，从而导致page fault。Page fault的处理函数MmAccessFault()可以分析出此次page fault是guard page导致，变会默认有用户栈处理程序MiCheckForUserStackOverflow()来处理。如果栈没有溢出，即Stack Commit Size小于Stack Reserve Size，MiCheckForUserStackOverflow()会自动扩展栈空间，扩展大小为一个GUARD_PAGE_SIZE。而GUARD_PAGE_SIZE对于x86和x64定义如下：

{% highlight C %}
#define GUARD_PAGE_SIZE (PAGE_SIZE * 2)     //x64
#define GUARD_PAGE_SIZE PAGE_SIZE           //x86
{% endhighlight %}

　　上面提到了Windows用户栈的一些特性，但是还没说明_chkstk的用途。想象这样的情况：当分配的栈空间被用尽后，一次性访问到超过一个guard page范围的空间，那么也会导致page fault，但是此时page fault处理程序不能识别此次page fault的原因。 

###References

[_chkstk Routine](http://msdn.microsoft.com/en-us/library/ms648426(v=vs.85).aspx)  
[从_chkstk说起，谈谈用户栈的管理](http://blog.dynox.cn/?p=1044)  
[堆栈分配检测函数chkstk执行过程分析](http://bbs.pediy.com/showthread.php?t=147689)
