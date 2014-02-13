---
layout: post
title: "从Duff设备到C语言协程"
description: "　　本文简要分析达夫设备的原理，并介绍一种C语言的协程实现。"
category: "program"
tags: [编程技巧, C]
---
{% include JB/setup %}

###达夫设备

　　[达夫设备](http://zh.wikipedia.org/wiki/%E8%BE%BE%E5%A4%AB%E8%AE%BE%E5%A4%87)是C语言的一个经典奇技淫巧，将switch语句块与循环语句块交错放置，从而实现一些特殊的目的。核心代码如下：

{% highlight C %}
send(to, from, count)
register short *to, *from;
register count;
{
    register n = (count + 7) / 8;
    switch(count % 8) {
    case 0: do {    *to = *from++;
    case 7:         *to = *from++;
    case 6:         *to = *from++;
    case 5:         *to = *from++;
    case 4:         *to = *from++;
    case 3:         *to = *from++;
    case 2:         *to = *from++;
    case 1:         *to = *from++;
            } while(--n > 0);
    }
}
{% endhighlight %}

　　暂且不管K&R C的古老语法和比较特殊的register关键字，以上代码基本可以改写为：

{% highlight C %}
char * DuffStrnCopy(char * dst, const char * from, int count)
{
    char * p = dst;
    int n = (count + 7) / 8; /* count > 0 assumed */
    switch (count % 8)
    {
        case 0: do {    *dst++ = *from++;
        case 7:         *dst++ = *from++;
        case 6:         *dst++ = *from++;
        case 5:         *dst++ = *from++;
        case 4:         *dst++ = *from++;
        case 3:         *dst++ = *from++;
        case 2:         *dst++ = *from++;
        case 1:         *dst++ = *from++;
                } while (--n > 0);
    }
    return p;
}
{% endhighlight %}

　　本文不对达夫设备的性能进行分析，只简要介绍其语法技巧。达夫设备的核心技巧在于：switch语句的case标号本质上与goto语句的标号是一样的，case标号可以加在switch的大括号内部的任意位置，跳转效果和goto完全一样。结合循环语句使用，于是得到了“选择循环入口点”的效果，并且只对第一次循环起作用。

###协程

　　[协程（cooperative routines）](http://zh.wikipedia.org/wiki/%E5%8D%8F%E7%A8%8B)可以认为是一种“轻量级的线程”，在逻辑上和线程是类似的，但开销比线程要小得多，通常情况下你可以轻松地创建数万乃至数十万个协程。

####References

[维基百科：达夫设备](http://en.wikipedia.org/wiki/Duff's_device)  
[一个“蝇量级”C语言协程库](http://coolshell.cn/articles/10975.html)  
[维基百科：协程](http://en.wikipedia.org/wiki/Coroutine)  
[Coroutines in C](http://www.chiark.greenend.org.uk/~sgtatham/coroutines.html)  

