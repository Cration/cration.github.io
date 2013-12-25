---
layout: post
title: "port x264 into kernel mode"
description: ""
category: ""
tags: []
---
{% include JB/setup %}

##文件准备

　　x264原目录结构：

    x264  
    │  .gitignore  
    │  AUTHORS  
    │  config.guess  
    │  config.sub  
    │  configure  
    │  COPYING  
    │  Makefile  
    │  version.sh  
    │  x264.c  
    │  x264.h  
    │  x264cli.h  
    │  x264dll.c  
    │  x264res.rc  
    │    
    ├─common  
    │  │  bitstream.c  
    │  │  bitstream.h  
    │  │  cabac.c  
    │  │  cabac.h  
    │  │  common.c  
    │  │  common.h  
    │  │  cpu.c  
    │  │  cpu.h  
    │  │  dct.c  
    │  │  dct.h  
    │  │  deblock.c  
    │  │  frame.c  
    │  │  frame.h  
    │  │  macroblock.c  
    │  │  macroblock.h  
    │  │  mc.c  
    │  │  mc.h  
    │  │  mvpred.c  
    │  │  opencl.c  
    │  │  opencl.h  
    │  │  osdep.c  
    │  │  osdep.h  
    │  │  pixel.c  
    │  │  pixel.h  
    │  │  predict.c  
    │  │  predict.h  
    │  │  quant.c  
    │  │  quant.h  
    │  │  rectangle.c  
    │  │  rectangle.h  
    │  │  set.c  
    │  │  set.h  
    │  │  threadpool.c  
    │  │  threadpool.h  
    │  │  vlc.c  
    │  │  win32thread.c  
    │  │  win32thread.h  
    │  │    
    │  ├─arm  
    │  │      asm.S  
    │  │      cpu-a.S  
    │  │      dct-a.S  
    │  │      dct.h  
    │  │      deblock-a.S  
    │  │      mc-a.S  
    │  │      mc-c.c  
    │  │      mc.h  
    │  │      pixel-a.S  
    │  │      pixel.h  
    │  │      predict-a.S  
    │  │      predict-c.c  
    │  │      predict.h  
    │  │      quant-a.S  
    │  │      quant.h  
    │  │        
    │  ├─opencl  
    │  │      bidir.cl  
    │  │      downscale.cl  
    │  │      intra.cl  
    │  │      motionsearch.cl  
    │  │      subpel.cl  
    │  │      weightp.cl  
    │  │      x264-cl.h  
    │  │        
    │  ├─ppc  
    │  │      dct.c  
    │  │      dct.h  
    │  │      deblock.c  
    │  │      mc.c  
    │  │      mc.h  
    │  │      pixel.c  
    │  │      pixel.h  
    │  │      ppccommon.h  
    │  │      predict.c  
    │  │      predict.h  
    │  │      quant.c  
    │  │      quant.h  
    │  │        
    │  ├─sparc  
    │  │      pixel.asm  
    │  │      pixel.h  
    │  │        
    │  └─x86  
    │          bitstream-a.asm  
    │          cabac-a.asm  
    │          const-a.asm  
    │          cpu-a.asm  
    │          dct-32.asm  
    │          dct-64.asm  
    │          dct-a.asm  
    │          dct.h  
    │          deblock-a.asm  
    │          mc-a.asm  
    │          mc-a2.asm  
    │          mc-c.c  
    │          mc.h  
    │          pixel-32.asm  
    │          pixel-a.asm  
    │          pixel.h  
    │          predict-a.asm  
    │          predict-c.c  
    │          predict.h  
    │          quant-a.asm  
    │          quant.h  
    │          sad-a.asm  
    │          sad16-a.asm  
    │          trellis-64.asm  
    │          util.h  
    │          x86inc.asm  
    │          x86util.asm  
    │            
    ├─doc  
    │      ratecontrol.txt  
    │      regression_test.txt  
    │      standards.txt  
    │      threads.txt  
    │      vui.txt  
    │        
    ├─encoder  
    │      analyse.c  
    │      analyse.h  
    │      cabac.c  
    │      cavlc.c  
    │      encoder.c  
    │      lookahead.c  
    │      macroblock.c  
    │      macroblock.h  
    │      me.c  
    │      me.h  
    │      ratecontrol.c  
    │      ratecontrol.h  
    │      rdo.c  
    │      set.c  
    │      set.h  
    │      slicetype-cl.c  
    │      slicetype.c  
    │        
    ├─extras  
    │  │  avisynth_c.h  
    │  │  avxsynth_c.h  
    │  │  cl.h  
    │  │  cl_platform.h  
    │  │  gas-preprocessor.pl  
    │  │  getopt.c  
    │  │  getopt.h  
    │  │  inttypes.h  
    │  │  stdint.h  
    │  │    
    │  └─windowsPorts  
    │          basicDataTypeConversions.h  
    │          windows2linux.h  
    │            
    ├─filters  
    │  │  filters.c  
    │  │  filters.h  
    │  │    
    │  └─video  
    │          cache.c  
    │          crop.c  
    │          depth.c  
    │          fix_vfr_pts.c  
    │          internal.c  
    │          internal.h  
    │          resize.c  
    │          select_every.c  
    │          source.c  
    │          video.c  
    │          video.h  
    │            
    ├─input  
    │      avs.c  
    │      ffms.c  
    │      input.c  
    │      input.h  
    │      lavf.c  
    │      raw.c  
    │      thread.c  
    │      timecode.c  
    │      y4m.c  
    │        
    ├─output  
    │      flv.c  
    │      flv_bytestream.c  
    │      flv_bytestream.h  
    │      matroska.c  
    │      matroska_ebml.c  
    │      matroska_ebml.h  
    │      mp4.c  
    │      mp4_lsmash.c  
    │      output.h  
    │      raw.c  
    │        
    └─tools  
        │  checkasm-a.asm  
        │  checkasm.c  
        │  cltostr.pl  
        │  countquant_x264.pl  
        │  q_matrix_jvt.cfg  
        │  test_x264.py  
        │  xyuv.c  
        │    
        └─digress  
            │  cli.py  
            │  comparers.py  
            │  constants.py  
            │  errors.py  
            │  testing.py  
            │  __init__.py  
            │    
            └─scm  
                    dummy.py  
                    git.py  
                    __init__.py  


　　搬运后目录结构：

    x264_kernel  
    │  x264.h  
    │  x264dll.c  
    │    
    ├─common  
    │  │  bitstream.c  
    │  │  bitstream.h  
    │  │  cabac.c  
    │  │  cabac.h  
    │  │  common.c  
    │  │  common.h  
    │  │  cpu.c  
    │  │  cpu.h  
    │  │  dct.c  
    │  │  dct.h  
    │  │  deblock.c  
    │  │  frame.c  
    │  │  frame.h  
    │  │  macroblock.c  
    │  │  macroblock.h  
    │  │  mc.c  
    │  │  mc.h  
    │  │  mvpred.c  
    │  │  opencl.c  
    │  │  opencl.h  
    │  │  osdep.c  
    │  │  osdep.h  
    │  │  pixel.c  
    │  │  pixel.h  
    │  │  predict.c  
    │  │  predict.h  
    │  │  quant.c  
    │  │  quant.h  
    │  │  rectangle.c  
    │  │  rectangle.h  
    │  │  set.c  
    │  │  set.h  
    │  │  threadpool.c  
    │  │  threadpool.h  
    │  │  vlc.c  
    │  │  win32thread.c  
    │  │  win32thread.h  
    │  │    
    │  ├─opencl  
    │  │      bidir.cl  
    │  │      downscale.cl  
    │  │      intra.cl  
    │  │      motionsearch.cl  
    │  │      subpel.cl  
    │  │      weightp.cl  
    │  │      x264-cl.h  
    │  │        
    │  └─x86  
    │          bitstream-a.asm  
    │          cabac-a.asm  
    │          const-a.asm  
    │          cpu-a.asm  
    │          dct-32.asm  
    │          dct-64.asm  
    │          dct-a.asm  
    │          dct.h  
    │          deblock-a.asm  
    │          mc-a.asm  
    │          mc-a2.asm  
    │          mc-c.c  
    │          mc.h  
    │          pixel-32.asm  
    │          pixel-a.asm  
    │          pixel.h  
    │          predict-a.asm  
    │          predict-c.c  
    │          predict.h  
    │          quant-a.asm  
    │          quant.h  
    │          sad-a.asm  
    │          sad16-a.asm  
    │          trellis-64.asm  
    │          util.h  
    │          x86inc.asm  
    │          x86util.asm  
    │            
    ├─encoder  
    │      analyse.c  
    │      analyse.h  
    │      cabac.c  
    │      cavlc.c  
    │      encoder.c  
    │      lookahead.c  
    │      macroblock.c  
    │      macroblock.h  
    │      me.c  
    │      me.h  
    │      ratecontrol.c  
    │      ratecontrol.h  
    │      rdo.c  
    │      set.c  
    │      set.h  
    │      slicetype-cl.c  
    │      slicetype.c  
    │        
    ├─filters  
    │  │  filters.c  
    │  │  filters.h  
    │  │    
    │  └─video  
    │          cache.c  
    │          crop.c  
    │          depth.c  
    │          fix_vfr_pts.c  
    │          internal.c  
    │          internal.h  
    │          resize.c  
    │          select_every.c  
    │          source.c  
    │          video.c  
    │          video.h  
    │            
    ├─input  
    │      avs.c  
    │      ffms.c  
    │      input.c  
    │      input.h  
    │      lavf.c  
    │      raw.c  
    │      thread.c  
    │      timecode.c  
    │      y4m.c  
    │        
    └─output  
            flv.c  
            flv_bytestream.c  
            flv_bytestream.h  
            matroska.c  
            matroska_ebml.c  
            matroska_ebml.h  
            mp4.c  
            mp4_lsmash.c  
            output.h  
            raw.c  


　　根目录建立：

makefile：

    # 
    # DO NOT EDIT THIS FILE!!!  Edit .\sources. if you want to add a new source 
    # file to this component.  This file merely indirects to the real make file 
    # that is shared by all the components of NT OS/2 
    # 
    !INCLUDE $(NTMAKEENV)\makefile.def 

makefile.inc

    _LNG=$(LANGUAGE)  
    _INX=.  
    STAMP=stampinf -f $@ -a $(_BUILDARCH) -k $(KMDF_VERSION_MAJOR).$(KMDF_VERSION_MINOR)  
      
    $(OBJ_PATH)\$(O)\$(INF_NAME).inf: $(_INX)\$(INF_NAME).inx   
        copy $(_INX)\$(@B).inx $@  
        $(STAMP)  

x264_kernel.def

    ;  
    ; DEF file for x264 kernel-mode DLL.  
    ;  
      
    NAME x264_kernel.sys  
      
    EXPORTS  
        DllInitialize PRIVATE  
        DllUnload     PRIVATE  
        x264_nal_encode  
        x264_param_default  
        x264_param_parse  
        x264_param_default_preset  
        x264_param_apply_fastfirstpass  
        x264_param_apply_profile  
        x264_picture_init  
        x264_picture_alloc  
        x264_picture_clean  
        x264_encoder_reconfig  
        x264_encoder_parameters  
        x264_encoder_headers  
        x264_encoder_encode  
        x264_encoder_close  
        x264_encoder_delayed_frames  
        x264_encoder_maximum_delayed_frames  
        x264_encoder_intra_refresh  
        x264_encoder_invalidate_reference  

x264_kernel.rc

    #include <windows.h>  
      
    #include <ntverp.h>  
      
    #define VER_FILETYPE                VFT_DRV  
    #define VER_FILESUBTYPE             VFT2_DRV_SYSTEM  
    #define VER_FILEDESCRIPTION_STR     "x264 Kernel-Mode Dll"  
    #define VER_INTERNALNAME_STR        "x264_kernel.sys"  
    #define VER_ORIGINALFILENAME_STR    "x264_kernel.sys"  
      
    #define VER_LANGNEUTRAL  
    #include "common.ver"  

sources

    TARGETNAME=x264_kernel  
    TARGETPATH=..\..\$(DDKBUILDENV)  
    TARGETTYPE=EXPORT_DRIVER  
      
    KMDF_VERSION_MAJOR=1  
      
    #  
    # Set the warning level high  
    #  
      
    MSC_WARNING_LEVEL=/W3 /WX  
      
    C_DEFINES=$(C_DEFINES)  
      
    DLLDEF=x264_kernel.def  
      
    SOURCES=x264kerneldll.c \  
            x264_kernel.rc \  
            common\bitstream.c \  
            common\cabac.c \  
            common\common.c \  
            common\cpu.c \  
            common\dct.c \  
            common\deblock.c \  
            common\frame.c \  
            common\macroblock.c \  
            common\mc.c \  
            common\mvpred.c \  
            common\opencl.c \  
            common\osdep.c \  
            common\pixel.c \  
            common\predict.c \  
            common\quant.c \  
            common\rectangle.c \  
            common\set.c \  
            common\threadpool.c \  
            common\vlc.c \  
            common\win32thread.c \  
            common\x86\bitstream-a.asm \  
            common\x86\cabac-a.asm \  
            common\x86\const-a.asm \  
            common\x86\cpu-a.asm \  
            common\x86\dct-32.asm \  
            common\x86\dct-64.asm \  
            common\x86\dct-a.asm \  
            common\x86\deblock-a.asm \  
            common\x86\mc-a.asm \  
            common\x86\mc-a2.asm \  
            common\x86\pixel-32.asm \  
            common\x86\pixel-a.asm \  
            common\x86\predict-a.asm \  
            common\x86\quant-a.asm \  
            common\x86\sad16-a.asm \  
            common\x86\trellis-64.asm \  
            common\x86\x86inc.asm \  
            common\x86\x86util.asm \  
            common\x86\mc-c.asm \  
            common\x86\mc-c.c \  
            common\x86\predict-c.c \  
            encoder\analyse.c \  
            encoder\cabac.c \  
            encoder\cavlc.c \  
            encoder\encoder.c \  
            encoder\lookahead.c \  
            encoder\macroblock.c \  
            encoder\me.c \  
            encoder\ratecontrol.c \  
            encoder\rdo.c \  
            encoder\set.c \  
            encoder\slicetype.c \  
            encoder\slicetype-cl.c \  
            filters\filters.c \  
            filters\video\cache.c \  
            filters\video\crop.c \  
            filters\video\depth.c \  
            filters\video\fix_vfr_pts.c \  
            filters\video\internal.c \  
            filters\video\resize.c \  
            filters\video\select_every.c \  
            filters\video\source.c \  
            filters\video\video.c \  
            input\avs.c \  
            input\ffms.c \  
            input\input.c \  
            input\lavf.c \  
            input\raw.c \  
            input\thread.c \  
            input\timecode.c \  
            input\y4m.c \  
            output\flv.c \  
            output\flv_bytestream.c \  
            output\matroska.c \  
            output\matroska_ebml.c \  
            output\mp4.c \  
            output\mp4_lsmash.c \  
            output\raw.c  
      
    TARGET_DESTINATION=wdf  




（编辑中）
