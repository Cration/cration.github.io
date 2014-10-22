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

* 编写一份 Processing 文件，如：RGBCube.pde 。  
* 创建一个包含 Processing.js 和 \ 的网页，同时插入 pde 文件。可以指定多个 pde 文件，用空格分割。

{% highlight javascript %}
<script src="processing.js"></script>
<canavs data-processing-sources="RGBCube.pde"></canvas>
{% endhighlight %}

2. 嵌入代码

* 如下

{% highlight javascript %}
<script src="processing.js"></script>
<script type ="text/processing" data-processing-target="mycanvas">

/**
 * RGB Cube.
 *
 * The three primary colors of the additive color model are red, green, and blue.
 * This RGB color cube displays smooth transitions between these colors.
 */

float xmag, ymag = 0;
float newXmag, newYmag = 0;

void setup()
{
    size(640, 360, P3D);
    noStroke();
    colorMode(RGB, 1);
}

void draw()
{
    background(0.5);

    pushMatrix();
    translate(width / 2, height / 2, -30);

    newXmag = mouseX / float(width) * TWO_PI;
    newYmag = mouseY / float(height) * TWO_PI;

    float diff = xmag - newXmag;
    if (abs(diff) >  0.01)
    {
        xmag -= diff / 4.0;
    }

    diff = ymag - newYmag;
    if (abs(diff) >  0.01)
    {
        ymag -= diff / 4.0;
    }

    rotateX(-ymag);
    rotateY(-xmag);

    scale(90);
    beginShape(QUADS);

    fill(0, 1, 1);
    vertex(-1,  1,  1);
    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);

    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);

    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(0, 0, 0);
    vertex(-1, -1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);

    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(0, 1, 1);
    vertex(-1,  1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);
    fill(0, 0, 0);
    vertex(-1, -1, -1);

    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(0, 1, 1);
    vertex(-1,  1,  1);

    fill(0, 0, 0);
    vertex(-1, -1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);

    endShape();

    popMatrix();
}

</script>
<canvas id="mycanvas"></canvas>
{% endhighlight %}


　　效果如下：

<script type ="text/processing" data-processing-target="mycanvas">

/**
 * RGB Cube.
 *
 * The three primary colors of the additive color model are red, green, and blue.
 * This RGB color cube displays smooth transitions between these colors.
 */

float xmag, ymag = 0;
float newXmag, newYmag = 0;

void setup()
{
    size(640, 360, P3D);
    noStroke();
    colorMode(RGB, 1);
}

void draw()
{
    background(0.5);

    pushMatrix();
    translate(width / 2, height / 2, -30);

    newXmag = mouseX / float(width) * TWO_PI;
    newYmag = mouseY / float(height) * TWO_PI;

    float diff = xmag - newXmag;
    if (abs(diff) >  0.01)
    {
        xmag -= diff / 4.0;
    }

    diff = ymag - newYmag;
    if (abs(diff) >  0.01)
    {
        ymag -= diff / 4.0;
    }

    rotateX(-ymag);
    rotateY(-xmag);

    scale(90);
    beginShape(QUADS);

    fill(0, 1, 1);
    vertex(-1,  1,  1);
    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);

    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);

    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(0, 0, 0);
    vertex(-1, -1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);

    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(0, 1, 1);
    vertex(-1,  1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);
    fill(0, 0, 0);
    vertex(-1, -1, -1);

    fill(0, 1, 0);
    vertex(-1,  1, -1);
    fill(1, 1, 0);
    vertex( 1,  1, -1);
    fill(1, 1, 1);
    vertex( 1,  1,  1);
    fill(0, 1, 1);
    vertex(-1,  1,  1);

    fill(0, 0, 0);
    vertex(-1, -1, -1);
    fill(1, 0, 0);
    vertex( 1, -1, -1);
    fill(1, 0, 1);
    vertex( 1, -1,  1);
    fill(0, 0, 1);
    vertex(-1, -1,  1);

    endShape();

    popMatrix();
}

</script>
<canvas id="mycanvas"></canvas>


-------------------------------------------

###References

[Processing.js 快速入门（JavaScript 开发者版）](http://chengyichao.info/processing-js-quickstart/)  
