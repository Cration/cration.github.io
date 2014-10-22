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

* 编写一份 Processing 文件，如：Flocking.pde 。  
* 创建一个包含 Processing.js 和 \ 的网页，同时插入 pde 文件。可以指定多个 pde 文件，用空格分割。

{% highlight javascript %}
<script src="processing.js"></script>
<canavs data-processing-sources="Flocking.pde"></canvas>
{% endhighlight %}

2. 嵌入代码

* 如下

{% highlight javascript %}
<script src="processing.js"></script>
<script type ="text/processing" data-processing-target="mycanvas">

/**
 * Flocking
 * by Daniel Shiffman.
 *
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on
 * rules of avoidance, alignment, and coherence.
 *
 * Click the mouse to add a new boid.
 */

Flock flock;

void setup()
{
    size(640, 360);
    flock = new Flock();
    // Add an initial set of boids into the system
    for (int i = 0; i < 150; i++)
    {
        flock.addBoid(new Boid(width / 2, height / 2));
    }
}

void draw()
{
    background(50);
    flock.run();
}

// Add a new boid into the System
void mousePressed()
{
    flock.addBoid(new Boid(mouseX, mouseY));
}

</script>
<canvas id="mycanvas"></canvas>
{% endhighlight %}


　　效果如下：

<script type ="text/processing" data-processing-target="mycanvas">

/**
 * Flocking
 * by Daniel Shiffman.
 *
 * An implementation of Craig Reynold's Boids program to simulate
 * the flocking behavior of birds. Each boid steers itself based on
 * rules of avoidance, alignment, and coherence.
 *
 * Click the mouse to add a new boid.
 */

Flock flock;

void setup()
{
    size(640, 360);
    flock = new Flock();
    // Add an initial set of boids into the system
    for (int i = 0; i < 150; i++)
    {
        flock.addBoid(new Boid(width / 2, height / 2));
    }
}

void draw()
{
    background(50);
    flock.run();
}

// Add a new boid into the System
void mousePressed()
{
    flock.addBoid(new Boid(mouseX, mouseY));
}

</script>
<canvas id="mycanvas"></canvas>


-------------------------------------------

###References

[Processing.js 快速入门（JavaScript 开发者版）](http://chengyichao.info/processing-js-quickstart/)  
