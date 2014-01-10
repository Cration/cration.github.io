---
layout: post
title: "在sublime text中搭建Processing运行环境"
description: "　　本文介绍了在sublime text中搭建Processing运行环境的方法。"
category: "program"
tags: [processing, sublime text]
---
{% include JB/setup %}

###操作流程

　　Processing是一款非常容易上手的数据可视化编程语言，语法和java非常类似，API和文档也都很完善，很适合用来快速开发一些小东西。但是processing自带的编辑器实在是不好用，字体、中文支持、自动完成等方面都不怎么样。

　　而sublime text的build system功能恰好可以用于这类场景。以下介绍配置方法。

>1. 安装sublime text和processing。  
2. 打开sublime text。  
3. 打开sublime text的菜单栏 → Tools → Build System → new build system。  
4. 复制[以下代码](#code)到编辑器中，并保存为“My_Processing.sublime-build”。  
5. 点击sublime text菜单栏 → Tools → Build System → My_Processing。  
6. 搭建完成，打开一个.pde文件，按ctrl+B进行测试。  

###代码
<span id="code"></span>
{{ hightlight }}
    {
        "shell":true,
        "path": "$file_path//temp",
        "cmd":[
                "C://Windows//System32//taskkill.exe",
                "-f",
                "-im",
                "java.exe",
                "&",
                "C://Program Files//processing-2.0b8//processing-java.exe",
                "--sketch=$file_path",
                "--output=$file_path/build",
                "--force",
                "--build",
                "--run"
            ]
    }
{{ endhighlight }}

###参考

【1】[http://ericfickes.tumblr.com/post/50480590889/processing-build-system-for-sublime-osx](http://ericfickes.tumblr.com/post/50480590889/processing-build-system-for-sublime-osx)  
【2】[sublime text 3 下载](http://www.sublimetext.com/3)  
【3】[processing 下载](http://processing.org/download/)  
