---
layout: post
title: "ARM中的条件执行指令"
description: "　　记录一次调试经历，并借此简单介绍ARM下的条件执行指令的概念。"
category: "Embedded"
tags: [ARM, asm]
---
{% include JB/setup %}

　　2014年03月01日晚上，收到学弟的求助，让帮忙看一个STM32的程序在IAR中的仿真异常现象。现象基本可以描述为：对于一个if分支结构，在仿真的时候单步跟踪，发现在if和else中的语句块都执行到了。贴个简化的代码：

{% highlight C %}
if (10 == x)
{
    y = 1;
}
else
{
    y = 2;
}
{% endhighlight %}

##调试总结

　　当然，以上代码只是示意，真正的应用中我们一般不会写出这样看似无意义的代码。简而言之，在单步跟踪的过程中，发现`y = 1;`和`y = 2`都执行到了，这显然不符合C语言的标准。

　　于是我打开汇编视图，发现在比较指令（CMP）后有一条指令：`IT EQ`，其后紧跟两个看似mov的指令，由于只学过x86汇编，对此也不太熟悉，就把两条都当作mov的某个变体了。查阅资料后得知，类似`IT EQ`的指令还有很多，例如`ITE`、`ITT`、`ITETT`等，都属于thumb指令集，是条件执行的指令。而跟在其后的mov也并非简单的mov指令，而是`MOVEQ`和`MOVNE`，分别是“MOVe (while) EQual”和“MOVe (while) Not Equal”的意思。而诸如此类的指令，在ARM中都称为“条件执行”的指令，只有当某种条件符合的时候（例如状态寄存器的某位被置位），该指令才真正执行相应的操作，否则不做任何处理。

　　如此便可以解释遇到的情况了。**虽然在单步跟踪时，进入了if的两个分支，看起来逻辑错误；然而实际上执行操作的只有一个分支**，是符合我们的期望的。由此也能得到一个教训：在嵌入式程序的调试中，单步调试和我们熟悉的在VC或VS中的含义并不一致，想了解代码运行的真实情况还是得观察汇编代码或是直接观察运行结果。

　　一般情况下，在if或else后面只跟了一两条简单语句（一般是能编译成四条以内的指令）时，需要特别注意条件执行的情况。因为设计条件执行特性的初衷是保证流水线的完整性，这种跳转地址只有几个字节的场景很容易被编译成条件执行。

##Thumb指令集中的IT指令

　　IT指令用于根据特定条件来执行紧随其后的1~4条指令，其格式为： IT[x[y[z]]] <firstcond>。其中x、y、z分别是执行第二、三、四条指令的条件，可取的值为T（then）或E（else），对应于<firstcond>条件的成立和不成立。<firstcond>称为条件字段，可取的值有：

<table class="table table-bordered table-striped table-condensed">
 <tr>
  <td>条件后缀</td><td>标志寄存器</td><td>含义</td>
 </tr>
 <tr>
  <td>EQ</td><td>Z == 1</td><td>等于</td>
 </tr>
 <tr>
  <td>NE</td><td>Z == 0</td><td>不等于</td>
 </tr>
 <tr>
  <td>CS/HS</td><td>C == 1</td><td>无符号大于或相同</td>
 </tr>
 <tr>
  <td>CC/LO</td><td>C == 0</td><td>无符号小于</td>
 </tr>
 <tr>
  <td>MI</td><td>N == 1</td><td>负数</td>
 </tr>
 <tr>
  <td>PL</td><td>N == 0</td><td>整数或零</td>
 </tr>
 <tr>
  <td>VS</td><td>V == 1</td><td>溢出</td>
 </tr>
 <tr>
  <td>VC</td><td>V == 0</td><td>无溢出</td>
 </tr>
 <tr>
  <td>HI</td><td>C == 1 && Z == 0</td><td>无符号大于</td>
 </tr>
 <tr>
  <td>LS</td><td>C == 1 || Z == 0</td><td>无符号小于或相同</td>
 </tr>
 <tr>
  <td>GE</td><td>N == V</td><td>有符号大于或等于</td>
 </tr>
 <tr>
  <td>LT</td><td>N != V</td><td>有符号小于</td>
 </tr>
 <tr>
  <td>GT</td><td>Z == 0 && N == V</td><td>有符号大于</td>
 </tr>
 <tr>
  <td>LE</td><td>Z == 1 || N != V</td><td>有符号小于或等于</td>
 </tr>
 <tr>
  <td>AL</td><td>任何</td><td>始终。不可用于B{cond}中</td>
 </tr>
</table>

　　看下面这个例子，意思是，当条件“EQ”符合时，执行指令1、3、4的mov操作，否则执行指令2的mov操作。

{% highlight C %}
ITETT   EQ
MOVEQ   R0, #1  ;//指令1
MOVNE   R0, #0  ;//指令2
MOVEQ   R1, #0  ;//指令3
MOVEQ   R2, #0  ;//指令4
{% endhighlight %}

　　此外，IT指令还有一些限制，如：

>不允许在 IT 块中使用下面的指令：  
>
>    * IT  
>    * 条件跳转  
>    * CBZ 和 CBNZ  
>    * TBB 和 TBH  
>    * CPS、CPSID 和 CPSIE  
>    * SETEND。  
>
>除以下两种情况外，均不允许跳进或跳出 IT 块：①IT 块的最后一条指令可为无条件跳转指令（IT指令会让其变为条件跳转）。 ②异常处理/恢复

-------------------------------------------

###References
[ARM/Thumb2PortingHowto](https://wiki.edubuntu.org/ARM/Thumb2PortingHowto)  
[ARM CPSR寄存器简介](http://www.cnblogs.com/shangdawei/archive/2012/09/13/2682871.html)  
[维基百科：ARM架构](http://en.wikipedia.org/wiki/ARM_architecture)  
[Thumb 16位指令集 快速参考卡](http://infocenter.arm.com/help/topic/com.arm.doc.qrc0006ec/QRC0006_UAL16.pdf)  
[RealView® 编译工具 汇编程序指南：IT](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0204hc/Cjabicci.html)  
[RealView 编译工具 《汇编器指南》：条件执行](http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0204ic/Cihbjcag.html)  

