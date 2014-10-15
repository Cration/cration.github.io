---
layout: post
title: "Altium Designer 中绘制图案和文本"
description: "　　介绍了一种用丝印绘制或镂空图案、文字的方法。"
category: "work"
tags: [PCB]
---
{% include JB/setup %}

　　在PCB设计过程中，可能需要通过丝印来绘制图案或文字。

### 绘制文字

　　如果仅仅是绘制文字，那就很简单，直接快捷键 "P->S"，然后输入文字即可。

### 绘制图案

　　若是绘制图案，可以通过插件 PCB Logo Creator 导入单色 bmp 图片，操作步骤如下。

　　[下载插件：PCB Logo Creator]({{site.resource_path}}/Altium Designer 2013 PCB Logo Creator.zip)  

　　首先，点击菜单栏的 "DXP->Run Script..."。

![PCB_Logo_Creator_1]({{site.img_path}}/PCB_Logo_Creator_1.png)

　　弹出一个对话框。点击对话框左下角的 "Browse"，打开刚才下载的插件安装包，选择 "PCBLogoCreator.PRJSCR"，选择 "Converter.PAS"，点击 "OK".

![PCB_Logo_Creator_2]({{site.img_path}}/PCB_Logo_Creator_2.png)

　　在弹出的对话框中点击 "Load"，选择一张单色位图（monochrome bitmap），选择图案在哪一层，然后点击 "Convert"完成转换。注意到下方有三个选项，分别是 __反色、X镜像、Y镜像__ 。

![PCB_Logo_Creator_3]({{site.img_path}}/PCB_Logo_Creator_3.png)

![PCB_Logo_Creator_4]({{site.img_path}}/PCB_Logo_Creator_4.png)


### 镂空、开孔

　　如果我们要在 top overlay 显示图中的 "Makeblock" 图案和 "Hello, world!" 文字，并且周围也是大块丝印。可以按照如下操作。

![PCB_draw_1]({{site.img_path}}/PCB_draw_1.png)

　　首先把 top overlay 的图案转成 top 层。

　　操作：选中图案（这里的图案实际上是一个元件），按下快捷键 "T->V->C"，将其转为 free primitive 。

　　框选中整个图案，右键 "Find Similar Objects..."，按照下图选择属性。

![PCB_draw_2]({{site.img_path}}/PCB_draw_2.png)

　　选择 Layer 为 Top Layer。

![PCB_draw_3]({{site.img_path}}/PCB_draw_3.png)

　　此时图案已转成 top layer 的元素。图中绿色是因为违反了布线规则，可以暂时无视。

![PCB_draw_4]({{site.img_path}}/PCB_draw_4.png)

　　然后在 Top Layer 放置覆铜。

![PCB_draw_5]({{site.img_path}}/PCB_draw_5.png)

　　选中覆铜，按下快捷键 "T->V->Y"，将覆铜转为 free primitive。

　　最后一步，将需要的图案转成 Top Overlay 层，然后复制到需要的地方。大功告成。

![PCB_draw_6]({{site.img_path}}/PCB_draw_6.png)

-------------------------------------------

###References

[Protel中将LOGO导入PCB的方法](http://jingyan.baidu.com/article/1e5468f9cd4623484961b72a.html)  
