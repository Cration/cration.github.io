---
layout: post
title: "Arduino中的电源选择电路"
description: "　　简要分析了Arduino中的电源选择电路。"
category: "electronic"
tags: []
---
{% include JB/setup %}

　　Arduino中使用到一个电源选择电路，用于选择外部电源或USB给电路板供电。原理图如下：

![原理图]({{site.img_path}}/arduino-power-supply-selector-schematic.png)

　　该电路的功能是：当外部电源电压VIN高于7V时，选用外部电源工作；当外部电源电压低于7V时，选用USB作为电源使用。

　　乍一看，此处使用的PMOS似乎把D极和S极接反了。如果按照图中的DS极反接的话，的确能实现预期功能，当外部电源电压高于7V时，PMOS截断，起到电源选择的作用。如果按照图中的接法，PMOS是不会截断的。

　　两种方式都可以实现电源选择的功能。若是采用图中的接法，可以实现一个额外的功能：若是图中的“5V”网络被加以一个高于5V的电压，那么这个电压将不会影响到USB口，起到保护作用。

###拓展

　　参照这个案例，设计了如下电路，使用PMOS代替二极管实现电源输入端防反接的功能。

![PMOS as diode]({{site.img_path}}/voltage_translator_PMOS_as_diode.png)

　　此电路能实现与二极管一样的防反接功能，而且压降极小。

-------------------------------------------

###References

[Arduino Power Supply Selector](http://www.engineeredentropy.com/2013/01/arduino-power-supply-selector/)  
[讨论：N-MOSFET电流能从S流向D吗？](http://www.elecinfo.com/bbs/60040.html)  
[什么是同步整流](http://www.haoming.cc/zs/1248/)  
[同步整流的基本原理](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=5&ved=0CDIQFjAE&url=http%3A%2F%2Fdownload.21dianyuan.com%2Fdownload.php%3Fid%3D44992&ei=4hCyU5P4GJL2oAS_k4GABg&usg=AFQjCNFGgTu5HLfuC4VCCYeLfExC9YpX5w&sig2=JCqtFgxZy7nkEq5QUdpxcQ)  
[PMOS NMOS简介和用例](http://hi.baidu.com/myfingerhurt/item/d4ef390d60e8c790a3df43a2)
