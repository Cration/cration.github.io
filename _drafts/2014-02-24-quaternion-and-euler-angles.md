---
layout: post
title: "四元数与欧拉角"
description: "　　本文简要介绍了四元数与欧拉角的定义，以及二者互相转换的方法。"
category: "math"
tags: [数学, 四轴]
---
{% include JB/setup %}

##欧拉角

　　欧拉角是一组用于描述刚体姿态的角度，欧拉提出，刚体在三维欧氏空间中的任意朝向可以由绕三个轴的转动复合生成。通常情况下，三个轴是相互正交的。对于描述旋转角的顺序，并没有特殊的规定，在航空航天领域，通常使用Tait–Bryan顺序，而对应的三个角度又分别成为roll（横滚角），pitch（俯仰角）和yaw（偏航角）。

　　以下四张图有助于直观理解roll，pitch和yaw。

<center><img src="{{site.img_path}}/opengl_roll.gif" alt="roll"/><p>roll</p></center>

<center><img src="{{site.img_path}}/opengl_pitch.gif" alt="pitch"/><p>pitch</p></center>

<center><img src="{{site.img_path}}/opengl_yaw.gif" alt="yaw"/><p>yaw</p></center>

<center><img src="{{site.img_path}}/opengl_yaw_pitch_roll.png" alt="yaw-pitch-roll"/><p>roll-pitch-yaw</p></center>

　　一般约定，绕x、y、z轴旋转的角分别是roll、pitch、yaw，分别记作$\varphi$、$\theta$、$\psi$。从参考坐标系上区分，欧拉角又分为静态和动态，其中静态欧拉角以绝对坐标系（地球）为参考，一般用小写的x-y-z来表示静态坐标系；动态欧拉角以刚体自身的坐标系为参考，一般用大写的X-Y-Z表示。

　　在本文中，我们讨论动态欧拉角，顺规为Z-Y-X。如下图所示：

<center><img src="{{site.img_path}}/Taitbrianzyx.png" alt="欧拉角定义"/><p>roll-pitch-yaw</p></center>

##四元数

　　四元数是复数在四维空间的扩展，由[哈密顿](http://zh.wikipedia.org/wiki/%E5%A8%81%E5%BB%89%C2%B7%E7%9B%A7%E9%9B%B2%C2%B7%E5%93%88%E5%AF%86%E9%A0%93)首次提出。从形式上看，四元数是由$1$和$\mathbf{i}$、$\mathbf{j}$、$\mathbf{k}$线性组合而成，其中$\mathbf{i}$、$\mathbf{j}$、$\mathbf{k}$和复数中的$\mathbf{i}$类似，定义如下：

$$\mathbf{i}^2=\mathbf{j}^2=\mathbf{k}^2=\mathbf{ijk}=-1$$

　　$\mathbf{i}$、$\mathbf{j}$、$\mathbf{k}$之间的运算关系还有：$\mathbf{ij}=\mathbf{k}$、$\mathbf{jk}=\mathbf{i}$、$\mathbf{ki}=\mathbf{j}$、$\mathbf{ji}=-\mathbf{k}$、$\mathbf{kj}=-\mathbf{i}$、$\mathbf{ik}=-\mathbf{j}$。注意到，这里交换律是不成立的。四元数的运算定义和运算法则，这里就不再介绍了，有需要可以参考[维基百科](http://en.wikipedia.org/wiki/Quaternion)。

　　要理解四元数与姿态的联系，首先得从欧拉旋转定理说起。欧拉旋转定理表明，任意的旋转序列等价于绕某个轴的单次旋转。如果我们能描述这个轴和旋转的角度，就能描述整个旋转序列等价的单次旋转。

　　若存在轴向量

$$\vec u=(u_x,u_y,u_z)=u_x\mathbf{i}+u_y\mathbf{j}+u_z\mathbf{k}$$

且旋转角为$\theta$，旋转方向为顺着轴向量看去的顺时针，那么描述该旋转的四元数为：

$$\mathbf{q}=e^{{frac{1}{2}}\theta(u_x\mathbf{i}+u_y\mathbf{j}+u_z\mathbf{k})}$$

###References
[维基百科：欧拉角](http://en.wikipedia.org/wiki/Euler_angles)  
[四元数和旋转以及yaw-pitch-roll-的含义](http://www.wy182000.com/2012/07/17/quaternion%E5%9B%9B%E5%85%83%E6%95%B0%E5%92%8C%E6%97%8B%E8%BD%AC%E4%BB%A5%E5%8F%8Ayaw-pitch-roll-%E7%9A%84%E5%90%AB%E4%B9%89/)  
[数的创生（四）哈密尔顿的四元数](http://songshuhui.net/archives/69990)  
[维基百科：欧拉旋转定理](http://en.wikipedia.org/wiki/Euler%27s_rotation_theorem)  
[维基百科：四元数与空间旋转](http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation)  
[维基百科：四元数](http://en.wikipedia.org/wiki/Quaternion)  
