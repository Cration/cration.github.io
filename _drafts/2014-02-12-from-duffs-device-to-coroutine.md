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

###协程

####References

[维基百科：达夫设备](http://en.wikipedia.org/wiki/Duff's_device)  
[一个“蝇量级”C语言协程库](http://coolshell.cn/articles/10975.html)  
