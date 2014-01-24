---
layout: post
title: "有限状态机的C语言实现"
description: "　　本文介绍了有限状态机的基本概念，以及状态表模式的C语言实现。"
category: "program"
tags: [有限状态机, C, 编程技巧]
---
{% include JB/setup %}

　　[有限状态机](http://en.wikipedia.org/wiki/Finite-state_machine)（Finite-State Machine），简称状态机，是一种非常有用的数学模型，可以作为世界上大多数事物和事件的抽象。有限状态机（以下简称FSM）的主要元素有：状态（State）、事件（Event）和动作（Action）。

　　先让我们看一个现实生活中的例子吧：如何优雅地摧毁地球（这TM算哪门子的现实生活啊？！）。我们知道，一个合格的程序员是不会写出“摧毁地球”这样的程序的，他会写一个名为“摧毁行星”的函数，然后把地球作为参数传进去；但是作为一名高端程序员，这么做还不够，我们还要实现摧毁恒星的功能，以达到良好的向前兼容。

　　于是我们实现了一个“星球毁灭器”。为了避免误操作，不能直接下达类似“摧毁地球”的指令，而应该先将机器目标锁定为地球，然后按下“摧毁”按钮。另外，由于恒星的体积一般比行星大得多，所以摧毁一颗恒星后，机器将进入过热状态，需要冷却后才能再次使用。用有限状态机可以描述为下图：

##References

[http://en.wikipedia.org/wiki/Finite-state_machine](http://en.wikipedia.org/wiki/Finite-state_machine)

