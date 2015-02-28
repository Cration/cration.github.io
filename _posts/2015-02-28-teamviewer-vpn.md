---
layout: post
title: "使用 TeamViewer 远程玩局域网游戏"
description: "　　记录了使用 TeamViewer 在广域网上和伙伴联机玩“魔兽争霸”、“火炬之光 2”等局域网游戏的方法。"
category: "work"
tags: [game, VPN]
---
{% include JB/setup %}

　　过年回家打算玩一玩“火炬之光 2”这款经典游戏，和朋友打算联机的时候就有了这个需求。先后找了 vLan、Hamachi，都无法顺利地使用，只得另寻他法。经过查找，发现常用于远程协作的 TeamViewer 有 VPN 功能。

　　首先前往官网[下载](http://download.teamviewer.com/download/TeamViewer_Setup.exe)并安装 TeamViewer。安装时注意勾选 VPN 功能。若是忘记勾选，也可以在安装之后，在“选项”中开启此功能。

![开启 VPN 功能]({{site.img_path}}/teamviewer1.png)

　　开启 VPN 功能后，打开 Windows 的“网络和共享中心”→“更改适配器设置”，将看到一个 TeamViewer VPN 连接。右键，属性，双击“Internet 协议版本 4 (TCP/IPv4)”。点击“高级”，将“接口跃点数”改为任意一个数字。**在伙伴的电脑上做同样的设置，双方的接口跃点数必须为同一个数字。**

![开启 VPN 功能]({{site.img_path}}/teamviewer2.png)

　　打开 TeamViewer，输入伙伴 ID 并选择 VPN 连接，等待伙伴确认之后，就可以打开游戏进行局域网连接了。

![开启 VPN 功能]({{site.img_path}}/teamviewer3.png)

-----------------------------------------------------------------

###References


