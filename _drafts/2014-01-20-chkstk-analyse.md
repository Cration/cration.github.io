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

###References

[_chkstk Routine](http://msdn.microsoft.com/en-us/library/ms648426(v=vs.85).aspx)  
[从_chkstk说起，谈谈用户栈的管理](http://blog.dynox.cn/?p=1044)  
[堆栈分配检测函数chkstk执行过程分析](http://bbs.pediy.com/showthread.php?t=147689)
