---
layout: post
title: "多键盘布局共存的实现"
description: "　　在Win 8.1下实现了dvorak和qwerty布局的共存和切换。"
category: "electronic"
tags: [电路]
---
{% include JB/setup %}

　　在Windows下，可以通过注册表来修改特定输入法的键盘布局。操作步骤如下：

* 按下“Win + R”，输入regedit，打开注册表。
* 找到 "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layouts" 。
* 点开 Keyboard Layouts ，里面的一大串就是各种语言和输入法的选项。
* 找到想要修改的输入法代码，例如00000804是微软自带的中文输入法。
* 将 Layout File 键值改成期望的键盘布局，键盘布局是由dll文件确定的，例如 "kbdus.dll" 是传统的 qwerty 布局， "kbddv.dll" 是 dvorak 布局。

　　笔者将必应输入法（E0200804）的布局改为dvorak ，微软自带中文输入法的布局改为 qwerty 。

-------------------------------------------

###References

[怎么让中文输入法完美支持programmer dvorak键盘布局？ - 知乎](http://www.zhihu.com/question/21950060)  
