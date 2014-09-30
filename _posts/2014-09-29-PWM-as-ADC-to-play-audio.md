---
layout: post
title: "用PWM实现音频播放"
description: "　　实现了一个用PWM来播放音频的方案。"
category: "electronic"
tags: [电路]
---
{% include JB/setup %}

　　用单片机音频播放的一个常用方法是用DAC输出音频数据，经过音频放大器后驱动喇叭来播放声音。如果所用的单片机没有DAC外设的话，我们也可以使用PWM口来模拟ADC的输出。

　　基本思路：用PWM经过低通滤波器来输出模拟电压，从而实现ADC的功能。

![原理框架]({{site.img_path}}/PWM_as_DAC_1.png)



-------------------------------------------

###References

[STR7/STR9 audio generation with PWM](http://www.st.com/st-web-ui/static/active/cn/resource/technical/document/application_note/CD00119860.pdf)  
[Arduino (ATmega) PWM audio DAC](http://wiki.openmusiclabs.com/wiki/PWMDAC)  
[PWM Distortion](http://www.openmusiclabs.com/learning/digital/pwm-dac/pwm-distortion-analysis/)  
[PWM as DAC](http://www.openmusiclabs.com/learning/digital/pwm-dac/)  
[Dual PWM Circuits](http://www.openmusiclabs.com/learning/digital/pwm-dac/dual-pwm-circuits/)  
[Combine two 8-bit outputs to make one 16-bit DAC](http://m.eet.com/media/1134628/15421-93004di.pdf)  
