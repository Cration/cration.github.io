---
layout: post
title: "使用 Processing 编写 Android 应用"
description: "　　介绍了使用 Processing 编写 Android 应用程序的全过程。"
category: "program"
tags: [Processing, Android]
---
{% include JB/setup %}

# 标题


Processing 的应用范围越来越广泛，甚至可以用来开发移动端的应用。本文主要介绍在 Windows 上搭建 Processing 的 Android 开发环境的流程。

大致步骤如下：

* [安装 JDK](#安装JDK)
* [安装 Android SDK](#安装Android_SDK)
* [安装 Processing](#安装Processing)
* [添加 Processing 的 Android 模式](#添加Processing的Android模式)
* [把 Processing 程序安装到 Android 手机](#aaa)


### 安装 JDK

　　打开 [oracle 官网](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)并下载你的操作系统对应版本的 JDK，双击安装即可。注意：是 JDK，不是 JRE。安装后，需要在系统环境变量里添加 java 编译器的路径。笔者的电脑里是：`C:\Program Files\Java\jdk1.8.0_25\bin;`

![JDK 环境变量]({{site.img_path}}/environment_variables_jdk.png)

### 安装Android_SDK

　　打开 [Android 官网](http://developer.android.com/sdk/index.html#Other)，下载 SDK。由于文件在 google 服务器上，可能需要翻墙。这里建议下载不带 SDK 的版本，因为我们要使用 Processing 作为 IDE。

　　安装完了之后，在开始菜单打开“SDK Manager”，若在开始菜单找不到，也可以到 SDK 的安装目录下找。

![SDK Magager 位置]({{site.img_path}}/sdk_manager.png)

　　打开后，勾选必要的包来安装，可能也需要翻墙安装。一般情况下，需要安装的有：

> * Tools: Android SDK Tools
> * Tools: Android SDK Platform-tools
> * Android 4.4.2(API 19): SDK Platform
> * Extras: Google USB Driver

<br>

![SDK Manager 安装]({{site.img_path}}/sdk_manager_install.png)

　　以上的第三项根据不同的手机系统平台而定，如果安装的版本不对，可能在后面的编译阶段出现类似 `Unable to resolve target 'android-19'` 的错误，到时候可以再回来安装对应版本的 SDK Platform。错误提示中的 `android-19` 表示需要的 API 版本号是 19。

### 安装Processing

　　打开 [Processing 官网](https://processing.org/download/?processing)，下载对应版本的并安装即可。

### 添加Processing的Android模式

　　打开 Processing，在右上角找到切换模式的按钮，点击“Add Mode...”，找到“Android Mode”并安装。

![切换 Processing 模式]({{site.img_path}}/processing_mode.png)

　　有些版本可能看不到“Android Mode”，那么需要手动[下载模式包](({{site.resource_path}}/AndroidMode.zip))并放到正确的目录（笔者的电脑里是：`C:\Users\Cration\Documents\Processing\modes`）下。

　　安装完模式之后，再次点击 Processing IDE 右上角的按钮，切换到 Android 模式。这时会出现弹窗询问 SDK 是否安装，点击“YES”，然后找到安装 SDK 的位置（笔者的电脑上是：`C:\Program Files\adt-bundle-windows-x86_64-20140702\sdk`），点击“Open”。随后 Processing 将以 Android 模式打开。

### 把Processing程序安装到Android手机(id:aaa)

　　将手机用数据线连接上 PC，并打开手机的 USB 调试功能。点击 Processing 菜单栏的 “File -> Examples...”，将打开例程列表。
　　
![安卓例程]({{site.img_path}}/processing_android_examples.png)

　　随意点开一个，然后点击左上角的“Run on Device”，就可以将程序编译并安装到 Android 手机上了。

![指南针]({{site.img_path}}/compass.gif)


-----------------------------------------------------------------

### References

[Bluetooth Android Processing 1](http://arduinobasics.blogspot.com/2013/03/arduino-basics-bluetooth-android.html)  
[在安卓手机上运行Processing程序的方法](http://www.eefocus.com/zhang700309/blog/14-12/307377_88e74.html)  

