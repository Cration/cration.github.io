---
layout: post
title: "浅析一个逻辑电平转换电路"
description: "　　简要分析了一个逻辑电平转换电路。"
category: "electronic"
tags: []
---
{% include JB/setup %}

　　在某个蓝牙模块的应用中发现一个3.3V和5V逻辑电平转换电路，用在蓝牙UART的传输中。原理图如下：

![原理图]({{site.img_path}}/voltage_translator_sch.png)

###分析

　　对于数字信号的传输，常见的有以下几种情况：

<table class="table table-bordered table-striped table-condensed">
 <tr>
  <td>左端状态</td><td>右端状态</td><td>编号</td>
 </tr>
 <tr>
  <td>推挽高电平</td><td>高阻上拉</td><td>编号</td>
 </tr>
 <tr>
  <td>推挽低电平</td><td>高阻上拉</td><td>编号</td>
 </tr>
 <tr>
  <td>弱上拉高电平</td><td>高阻上拉</td><td>编号</td>
 </tr>
 <tr>
  <td>高阻上拉</td><td>推挽高电平高阻上拉</td><td>编号</td>
 </tr>
 <tr>
  <td>高阻上拉</td><td>推挽低电平</td><td>编号</td>
 </tr>
 <tr>
  <td>高阻上拉</td><td>弱上拉高电平</td><td>编号</td>
 </tr>
</table>

-------------------------------------------

###References


