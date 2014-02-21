---
layout: post
title: "使用SSE实现RGB到YUV的色彩空间转换"
description: "　　本文给出了一种使用SSE指令集将图像进行RGB到YUV的色彩空间转换的实现。"
category: "program"
tags: [asm, 编程技巧]
---
{% include JB/setup %}

　　RGB和YUV是计算机中常用的两种颜色编码方法，在图像压缩领域，经常要实现高效的RGB和YUV互相转换的功能。由于颜色空间转换具有数据高度密集且分布规律的特点，许多情况下可以使用现代CPU的SIMD功能。本文给出一种实现方式，实现了从ARGB到YUV420 planar格式的转换，其中ARGB的alpha分量不起作用，一般认为是0。

　　代码中带有“ ;///////////// ”后缀注释的代码，在下方都能找到相应的被注释掉的代码，这是由于对指令做了人工乱序的处理，能少许提升性能。

　　以下代码主要做了几点优化：  
　　　　①替代浮点数运算为整数运算  
　　　　②并行计算多个像素点  
　　　　③指令乱序

{% highlight asm %}
/**
 * @brief RGB转YUV
 *
 * @param[in]   pARGB        数据起始地址 : uint8_t *
 *              _length      图片长度 : uint32_t
 *              _height      图片高度 : uint32_t
 *              _originX     图片原始长度 : uint32_t
 *              _originY     图片原始高度 : uint32_t
 *              outY         Y分量起始地址 : uint8_t *
 *              outU         U分量起始地址 : uint8_t *
 *              outV         V分量起始地址 : uint8_t *
 *
 * @return  0
 * 
 * @note 
 */
static int RGB2YUV(uint8_t * pARGB, 
                   uint32_t _length, uint32_t _height, 
                   uint32_t _originX, uint32_t _originY, 
                   uint8_t * outY, uint8_t * outU, uint8_t * outV)
{
    uint32_t lastY = _originY - 1;
    _asm
    {
    xor edx, edx

    mov edi, outY
    mov eax, outU
    mov ebx, outV

    movdqa xmm4, xmmword ptr [yCoeffRB]
    movdqa xmm5, xmmword ptr [yCoeff0G]

LoopOut:
        mov esi, _originX
        imul esi, edx
        shl esi, 2
        add esi, [pARGB]

        mov ecx, _length
        shr ecx, 2

        cmp edx, lastY              ;//避免读取越界
        jne doNothing1              ;//
        dec ecx                     ;//
doNothing1:

        movdqa xmm6, xmmword ptr [uCoeffRB]
        movdqa xmm7, xmmword ptr [uCoeff0G]

LoopIn1:
            ;//准备数据
            movdqu xmm0, xmmword ptr [esi]
            movdqa xmm1, xmm0

            add esi, 16

            psllw xmm0, 8
            psrlw xmm1, 8           ;//xmm1 = 0A0G)3 0A0G)2 0A0G)1 0A0G)0
            psrlw xmm0, 8           ;//xmm0 = 0R0B)3 0R0B)2 0R0B)1 0R0B)0
            movdqa xmm3, xmm1
            movdqa xmm2, xmm0
            
            prefetcht0 [esi]
            
            ;//计算Y分量
            pmaddwd xmm0, xmm4
            pmaddwd xmm2, xmm6      ;/////////////
            prefetcht0 [edi]
            pmaddwd xmm1, xmm5
            pmaddwd xmm3, xmm7      ;/////////////
            prefetcht0 [eax]
            paddd xmm0, xmm1
            paddd xmm2, xmm3        ;/////////////
            psrad xmm0, 15          ;//xmm0 = Y3 Y2 Y1 Y0
            psrad xmm2, 15          ;/////////////

            ;//保存Y分量
            packuswb xmm0, xmm1
            paddd xmm2, xmmword ptr [uvAdds]    ;//////////////
            packuswb xmm0, xmm1     ;//xmm0 = __ __ __ __ __ __ __ __ __ __ __ __ Y3 Y2 Y1 Y0
            pshufd xmm3, xmm2, 177  ;//////////////
            movd [edi], xmm0

            ;//计算U分量
            ;//pmaddwd xmm2, xmm6
            ;//pmaddwd xmm3, xmm7
            ;//paddd xmm2, xmm3
            ;//psrad xmm2, 15
            ;//paddd xmm2, xmmword ptr [uvAdds]        ;//xmm2 = U3 U2 U1 U0
            ;//pshufd xmm3, xmm2, 177
            pavgw xmm2, xmm3        ;//xmm2 = __ (U3+U2)/2 __ (U1+U0)/2

            ;//保存U分量
            pextrb byte ptr [eax], xmm2, 0
            pextrb byte ptr [eax + 1], xmm2, 8

        ;//add esi, 16
        add edi, 4
        add eax, 2
        loop LoopIn1

        inc edx
        cmp edx, _originY
        jne nextLine                ;//若抵达最后一行，则回退一行，
        dec edx                     ;//让V分量继续读取当前行

nextLine:
        ;//第二行的计算
        mov ecx, _length
        shr ecx, 2

        cmp edx, lastY              ;//避免读取越界
        jne doNothing2              ;//
        dec ecx                     ;//
doNothing2:

        mov esi, [_originX]
        imul esi, edx
        ;//add esi, [_stride]
        shl esi, 2
        add esi, [pARGB]

        movdqa xmm6, xmmword ptr [vCoeffRB]
        movdqa xmm7, xmmword ptr [vCoeff0G]

LoopIn2:
            ;//第二行的数据
            movdqu xmm0, xmmword ptr [esi]
            movdqa xmm1, xmm0

            add esi, 16

            psllw xmm0, 8
            psrlw xmm1, 8           ;//xmm1 = 0A0G)3 0A0G)2 0A0G)1 0A0G)0
            psrlw xmm0, 8           ;//xmm0 = 0R0B)3 0R0B)2 0R0B)1 0R0B)0
            movdqa xmm3, xmm1
            movdqa xmm2, xmm0

            prefetcht0 [esi]
                        
            ;//计算第二行Y分量
            pmaddwd xmm0, xmm4
            pmaddwd xmm2, xmm6      ;///////////////
            prefetcht0 [edi]
            pmaddwd xmm1, xmm5
            pmaddwd xmm3, xmm7      ;///////////////
            prefetcht0 [ebx]
            paddd xmm0, xmm1
            paddd xmm2, xmm3        ;///////////////
            psrad xmm0, 15          ;//xmm0 = Y3 Y2 Y1 Y0
            psrad xmm2, 15          ;///////////////
            

            ;//保存第二行的Y分量
            packuswb xmm0, xmm1
            paddd xmm2, xmmword ptr [uvAdds]    ;/////////////////
            packuswb xmm0, xmm1     ;//xmm0 = __ __ __ __ __ __ __ __ __ __ __ __ Y3 Y2 Y1 Y0
            pshufd xmm3, xmm2, 177  ;////////////////
            movd [edi], xmm0


            ;//计算V分量
            ;//pmaddwd xmm2, xmm6
            ;//pmaddwd xmm3, xmm7
            ;//paddd xmm2, xmm3
            ;//psrad xmm2, 15
            ;//paddd xmm2, xmmword ptr [uvAdds]        ;//xmm2 = V3 V2 V1 V0
            ;//pshufd xmm3, xmm2, 177
            pavgw xmm2, xmm3        ;//xmm2 = (V3+V2)/2 (V3+V2)/2 (V1+V0)/2 (V1+V0)/2

            ;//保存V分量
            pextrb byte ptr [ebx], xmm2, 0
            pextrb byte ptr [ebx + 1], xmm2, 8
    
        ;//add esi, 16
        add edi, 4
        add ebx, 2
        loop LoopIn2

    ;//add edx, 2
    inc edx
    cmp edx, _originY
    jl LoopOut
    
// funcEnd:
    mov dword ptr [edi], 0
    mov word ptr [eax], 8080H
    mov word ptr [ebx], 8080H
    }

    return 0;
}
{% endhighlight %}

###References
[维基百科：色彩空间](http://en.wikipedia.org/wiki/Color_space)  
[维基百科：色彩模型](http://en.wikipedia.org/wiki/Color_model)  
[维基百科：SIMD](http://en.wikipedia.org/wiki/SIMD)  
[Optimizing YUV-RGB Color Space Conversion Using Intel’s SIMD Technology](http://lestourtereaux.free.fr/papers/data/yuvrgb.pdf)  
