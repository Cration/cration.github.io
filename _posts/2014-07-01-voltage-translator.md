---
layout: post
title: "浅析一个逻辑电平转换电路"
description: "　　简要分析了一个逻辑电平转换电路。"
category: "electronic"
tags: []
---
{% include JB/setup %}

　　在某个蓝牙模块的应用中发现一个3.3V和5V逻辑电平转换电路，用在蓝牙UART的传输中。原理图如下：

![原理图]({{site.img_path}}/voltage_translator_schematic.png)

　　图中VCC是为5V。

###分析

　　对于数字信号的传输，常见的有以下几种情况：

<table class="table table-bordered table-striped table-condensed">
 <tr>
  <td>左端状态</td><td>右端状态</td><td>编号</td>
 </tr>
 <tr>
  <td>推挽高电平</td><td>高阻弱上拉</td><td>1</td>
 </tr>
 <tr>
  <td>推挽低电平</td><td>高阻弱上拉</td><td>2</td>
 </tr>
 <tr>
  <td>弱上拉高电平</td><td>高阻弱上拉</td><td>3</td>
 </tr>
 <tr>
  <td>高阻弱上拉</td><td>推挽高电平</td><td>4</td>
 </tr>
 <tr>
  <td>高阻弱上拉</td><td>推挽低电平</td><td>5</td>
 </tr>
 <tr>
  <td>高阻弱上拉</td><td>弱上拉高电平</td><td>6</td>
 </tr>
</table>

　　针对以上六种情况逐一分析：

####编号1 <span id="编号1"></span>

　　左端输出推挽高电平，NMOS截止，于是右端被上拉至5V。成功传输高电平。

####编号2 <span id="编号2"></span>

　　左端输出推挽低电平，NMOS导通，于是右端被短路到GND。成功传输低电平。

####编号3 <span id="编号3"></span>

　　左端输出弱上拉高电平，情况与[编号1](#编号1)一样。成功传输高电平。

####编号4 <span id="编号4"></span>

　　右端输出推挽高电平，左端高阻上拉，于是NMOS截止，左端仍然处于高电平状态。成功传输高电平。

####编号5 <span id="编号5"></span>

　　右端输出推挽低电平，左端高阻上拉。首先有电流通过NMOS的体二极管，于是左端电压被拉到0.7V左右，此时将导致NMOS导通（因为Vgs超过阈值）呈现低阻态，进一步使得左端电压被拉到GND。成功传输低电平。

####编号6 <span id="编号6"></span>

　　 右端输出弱上拉高电平，情况与[编号4](#编号4)一样。成功传输高电平。

-------------------------------------------
