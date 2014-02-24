---
layout: post
title: "四元数与欧拉角"
description: "　　本文简要介绍了四元数与欧拉角的定义，以及二者互相转换的方法。"
category: "math"
tags: [数学, 四轴]
---
{% include JB/setup %}

　　欧拉角是一组用于描述刚体姿态的角度，欧拉提出，刚体在三维欧氏空间中的任意朝向可以由绕三个轴的转动复合生成。通常情况下，三个轴是相互正交的。对于描述旋转角的顺序，并没有特殊的规定，在航空航天领域，通常使用Tait–Bryan顺序，而对应的三个角度又分别成为roll（横滚角），pitch（俯仰角）和yaw（偏航角）。

　　以下四张图有助于直观理解roll，pitch和yaw。

<center><img src="{{site.img_path}}/opengl_roll.gif" alt="roll"/><p>roll</p></center>

<center><img src="{{site.img_path}}/opengl_pitch.gif" alt="pitch"/><p>pitch</p></center>

<center><img src="{{site.img_path}}/opengl_yaw.gif" alt="yaw"/><p>yaw</p></center>

<center><img src="{{site.img_path}}/opengl_yaw_pitch_roll.png" alt="yaw-pitch-roll"/><p>roll-pitch-yaw</p></center>

　　一般约定，绕x、y、z轴旋转的角分别是roll、pitch、yaw，分别记作$\varphi$、$\theta$、$\psi$。从参考坐标系上区分，欧拉角又分为静态和动态，其中静态欧拉角以绝对坐标系（地球）为参考，动态欧拉角以刚体自身的坐标系为参考。

###References
[维基百科：欧拉角](http://en.wikipedia.org/wiki/Euler_angles)  
[四元数和旋转以及yaw-pitch-roll-的含义](http://www.wy182000.com/2012/07/17/quaternion%E5%9B%9B%E5%85%83%E6%95%B0%E5%92%8C%E6%97%8B%E8%BD%AC%E4%BB%A5%E5%8F%8Ayaw-pitch-roll-%E7%9A%84%E5%90%AB%E4%B9%89/)  
