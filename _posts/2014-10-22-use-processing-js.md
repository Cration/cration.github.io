---
layout: post
title: "在网页中使用 processing 语言"
description: "　　在网页中使用 processing.js 显示动画等。"
category: "program"
tags: [processing]
---
{% include JB/setup %}

　　Processing.js 是一个 Javascript 文件，可以将 Processing 语言转换成 Javascript 在浏览器中运行，使用 \ 作为绘图的表面。[点此下载 Processing.js](http://processingjs.org/download/) 。

　　使用方法：

1. 文件引用

* 编写一份 Processing 文件，如：draw.pde 。  
* 创建一个包含 Processing.js 和 \ 的网页，同时插入 pde 文件。可以指定多个 pde 文件，用空格分割。

{% highlight javascript %}
<script src="processing.js"></script>
<canavs data-processing-sources="hello-web.pde"></canvas>
{% endhighlight %}

2. 嵌入代码

* 如下

{% highlight javascript %}
<script src="processing.js"></script>
<script type ="text/processing" data-processing-target="mycanvas">

void setup()
{
    size(600, 300);
    noFill();
    smooth();
    strokeWeight(6);
    stroke(255);
    frameRate(33);//帧率，一帧0.33秒
}
void draw()
{
    background(#836aff);
    translate(width / 2, height / 2); //平移画布到中间
    rotate(PI / 10 * frameCount); //每帧旋转角度
    //绘制两条曲线
    if((frameCount >= 0) && (frameCount < 6))
    {
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5));
    }
    //改变终点让曲线变大变小
    if((frameCount >= 6) && (frameCount < 26))
    {
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 - 5 / 20 * (frameCount - 6)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 - 5 / 20 * (frameCount - 6)));
    }
    if((frameCount >= 26) && (frameCount < 46))
    {
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 / 20 * (frameCount - 26)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 / 20 * (frameCount - 26)));
    }
    if((frameCount >= 46) && (frameCount < 69))
    {
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 - 5 / 23 * (frameCount - 46)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 - 5 / 23 * (frameCount - 46)));
    }
    if((frameCount >= 69) && (frameCount < 89))
    {
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 / 20 * (frameCount - 69)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 / 20 * (frameCount - 69)));
    }
    //曲线缩放
    if((frameCount >= 89) && (frameCount < 109))
    {
        scale(1 - 1 / 20 * (frameCount - 89));
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 - 5 / 20 * (frameCount - 89)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 - 5 / 20 * (frameCount - 89)));
    }
    if((frameCount >= 113) && (frameCount < 130))
    {
        scale(1 / 20 * (frameCount - 89) - 1);
        arc(0, 0, 70, 70, -PI / 6, PI / 6 * (-1 + 5 / 17 * (frameCount - 113)));
        arc(0, 0, 70, 70, PI / 6 * 5, PI / 6 * (5 + 5 / 17 * (frameCount - 113)));
    }
    //循环动画
    if(frameCount == 130)
    {
        frameCount = 0;
    }
}
</script>
<canvas id="mycanvas"></canvas>
{% endhighlight %}

-------------------------------------------

###References

[Processing.js 快速入门（JavaScript 开发者版）](http://chengyichao.info/processing-js-quickstart/)  
