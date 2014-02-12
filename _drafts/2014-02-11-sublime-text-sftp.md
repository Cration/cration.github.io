---
layout: post
title: "sublime text SFTP"
description: "　　本文介绍了在sublime text中使用FTP插件进行远程编辑的配置方法。"
category: "work"
tags: [ftp, sftp, sublime text]
---
{% include JB/setup %}

　　在工作过程中，我们有时需要编辑远程服务器上的文档，常用的方法是：

*从服务器上下载文档*
*编辑文档*
*上传文档到服务器*

　　这样不仅繁琐，而且容易出错。幸运的是，许多现代编辑器都提供了直接编辑FTP/SFTP上的文档的功能。以下介绍在sublime text中配置FTP编辑功能的方法。

###WIN7中搭建FTP服务器

　　为了演示，第一步是搭建FTP服务器，如果已有FTP服务器，可以跳过这一步。

　　一、打开控制面板中的“打开或关闭Windows功能”。

![打开关闭Windows功能]({{site.img_path}}/WIN7_FTP_1.png)

　　二、勾选下图所示的选项。

![控制面板FTP选项]({{site.img_path}}/WIN7_FTP_2.png)

　　三、打开控制面板中的“管理工具”，选择其中的“IIS管理器”。

![控制面板管理工具]({{site.img_path}}/WIN7_FTP_3.png)

![IIS管理器]({{site.img_path}}/WIN7_FTP_4.png)

　　四、右键点击“网站”→“添加FTP站点”。

![添加FTP站点]({{site.img_path}}/WIN7_FTP_5.png)

　　五、依次按照图示操作。这里因为是演示，所以在最后的权限控制上选择了所有用户可读写，在实际应用中可以按需要设置。

![FTP设置6]({{site.img_path}}/WIN7_FTP_6.png)

![FTP设置7]({{site.img_path}}/WIN7_FTP_7.png)

![FTP设置8]({{site.img_path}}/WIN7_FTP_8.png)

###sublime text中安装FTP插件


###配置FTP插件
