---
layout: post
title: "JD-385 二次开发【持续更新】"
description: "　　本文记录对微型四轴飞行器JD-385进行二次开发的历程和心得，将不定时持续更新。"
category: "Embedded"
tags: [嵌入式, 四轴]
---
{% include JB/setup %}


####2014-01-13

　　烧录问题还未解决，今晚本打算把原理图复原出来，刚开始没多久，万用表没电了，只好作罢。确认有源晶振（16MHz）是用于BK2423上的，BK2423的典型应用如下图：

[![BK2423应用]({{site.img_path}}/BK2423_typical_application_schematic.png)](http://www.inhaos.com/uploadfile/otherpic/BK2423%20Datasheet%20v2.0.pdf)

-----------------------------------------------------------------

####2014-01-09

　　入手一只JD-385，奈何第一天就摔坏电机（空心杯7*20），只好拆开来二次开发玩一玩了。先上个全貌：

[![全貌]({{ site.img_path }}/JD385-1.png)](http://www.spyshop.si/en/za-dom/i_522_leteci-vragec-super-mini-quadcopter-rtf-2-4ghz-w-6-axis-gyro-x4-hubsan)

　　开机后，按惯例，上下推动油门解锁，试飞了十几分钟，感觉不是很好掌控，飞得不太稳。在测试空翻功能时，不幸底朝天从两米多高摔落，导致一个电机摔坏。

　　不多说，直接拆去机壳，焊掉四个电机，剩下的就是电路板了，看了一下丝印，2013年08月22日产，不算太老。板子正面，主要芯片就三个：主控[MINI54ZAN](http://www.digchip.com/datasheets/parts/datasheet/2103/MINI54ZAN.php)（新唐的Cortex-M0系列），惯性模块[MPU6050](http://invensense.com/mems/gyro/documents/PS-MPU-6000A-00v3.4.pdf)，以及2.4GHz的[BK2423](http://www.inhaos.com/uploadfile/otherpic/BK2423%20Datasheet%20v2.0.pdf)。还算是良心产商，没把芯片型号磨掉。

　　再观察芯片周边，有两排的排针孔，看丝印应该分别是仿真/烧录口和串口，果然是良心产商。翻面，一个有源晶振，可能是BK2423或MINI54ZAN的时钟；五个看起来像是三极管的元件，可以确定其中四个是三极管，用来驱动电机的。剩下的基本都是电阻电容二极管之类的，看来复原原理图没有太大难度。

　　随后和队友张翼聊了一会儿，得知有[PL2303+MSP430+BK2423的模块](http://item.taobao.com/item.htm?spm=a230r.1.14.1.Im3rUB&id=35461779758)，看来PC和主控的通信问题也能解决了。然后是单片机烧录器，手头有一块STM32F407-Discovery，不知上面的ST-LINK是否可以用于烧录。

-----------------------------------------------------------------



##References
[http://www.inhaos.com/uploadfile/otherpic/BK2423%20Datasheet%20v2.0.pdf](http://www.inhaos.com/uploadfile/otherpic/BK2423%20Datasheet%20v2.0.pdf)  

