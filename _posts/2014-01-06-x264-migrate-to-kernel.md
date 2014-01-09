---
layout: post
title: "x264内核移植"
description: "　　本文简要介绍了将x264编码器移植到Windows内核态，编译成内核dll的方法。"
category: "Program"
tags: [x264, mingw, 驱动开发]
---
{% include JB/setup %}

　　本文简要介绍了将x264编码器移植到Windows内核态，编译成内核dll的方法。

##编译x264

　　由于x264使用到大量gcc和C99的特性，想要在Windows下编译，必须使用mingw环境（Visual Studio也可以，但需要改动和删除一些代码）。

　　编译步骤如下：

>* [下载](http://sourceforge.net/projects/mingw/files/)并安装mingw（集成msys）。
* [下载](http://download.videolan.org/pub/videolan/x264/)x264代码。
* 将x264工程放到msys的"home/[user]"目录下。
* 运行msys，进入x264工程目录。
* 执行configure脚本。配置选项可以在脚本中看到。
* make，编译完成。
* 若需要.lib文件，可以通过[pexports](http://sourceforge.net/projects/mingw/files/MinGW/Extension/pexports/)导出。

　　通过配置选项，可以编译出x264.exe和x264的dll库。接下来介绍如何将x264编译为内核dll，也就是内核态下的动态链接库，以.sys文件形式存在。

##内核dll
　　
　　Tim Roberts在[“DLLs in Kernel Mode”](http://www.wd-3.com/archive/KernelDlls.htm)中介绍了构建内核dll的方法。在此引用并节选翻译。

　　内核dll和用户态dll的使用是类似的，在连接时包含一个导入库，这样，运行时就可以使用对应动态链接库的函数了。

　　内核dll与普通的内核态程序最大的区别在于，sources文件中的TARGETTYPE。为了创建一个内核dll，我们需要在sources文件中指定宏：`TARGETTYPE=EXPORT_DRIVER`。

　　然后，内核dll必须包含一个DriverEntry，实际上该入口点不会被调用到，但为了编译通过，我们必须创建一个。

{% highlight C %}
    NTSTATUS
    DriverEntry(IN PDRIVER_OBJECT DriverObject,
                IN PUNICODE_STRING RegistryPath)
    {
        return STATUS_SUCCESS;
    }
{% endhighlight %}

　　如果需要在dll加载和卸载的时候做一些处理，那么我们需要加上DllInitialize和DllUnload这两个函数，在这里，我们且加个空函数备用。

{% highlight C %}
    NTSTATUS
    DllInitialize(IN PUNICODE_STRING RegistryPath)
    {
        return STATUS_SUCCESS;
    }

    NTSTATUS
    DllUnload(void)
    {
        return STATUS_SUCCESS;
    }
{% endhighlight %}

　　除了以上三个函数外，我们还可以导出其他函数，可以在.def文件中添加函数名，或是在函数定义和声明时加上`__declspec(dllexport)`前缀。当然，我们需要在sources文件中使用宏来指定.def文件的名字：`DLLDEF=xxx.def`。

　　需要注意的是，DllInitialize和DllUnload必须标记为PRIVATE导出。

　　以上就是构建内核dll的基本要点，其他细节与普通的内核态程序基本一样。接下来介绍如何将x264编译为内核dll。

##x264的内核移植

　　由于x264代码中有大量的gcc和C99特性，不便直接使用WDK环境进行编译，于是我们考虑使用mingw的gcc进行编译，然后使用WDK环境进行连接，生成.sys文件。编译的过程和在用户态下编译x264没有什么区别。

　　需要注意的是，有些函数在内核态是无法使用的，如文件操作和内存操作方面的函数，这时候，则需要我们找到替代函数或自己实现其功能。

　　在实现和替代了相关函数之后，需要为导出函数的声明和定义添加`__declspec(dllexport) __stdcall`，由于WDK默认的调用约定是__stdcall，与gcc默认的不一致，此处需要添加__stdcall声明。

　　修改代码后，将编译得到的.o文件添加到sources文件的TARGETLIBS宏列表中，并添加一些必须的库，如libgcc.a，libquadmath.a等。

　　添加完成后，使用WDK环境进行build即可。


##References

[DLLs in Kernel Mode - Tim Roberts](http://www.wd-3.com/archive/KernelDlls.htm)  
[浅谈如何使用gcc开发NT核心驱动](http://blog.csdn.net/mydo/article/details/2281887)  
[使用VC创建Windows NT下的内核dll和lib](http://bbs.pediy.com/showthread.php?t=102426)  
[设置编译内核lib驱动及应用层dll的sources文件](http://laokaddk.blog.51cto.com/368606/413263/)  
[Win32 driver development using MinGW](http://www.fccps.cz/download/adv/frr/win32_ddk_mingw/win32_ddk_mingw.html)  
[Calling a DLL in a Kernel-Mode Driver](http://msdn.microsoft.com/en-us/windows/hardware/gg463187.aspx)  
[WinKVM: Windows Kernel-based Virtual Machine](http://www.linux-kvm.org/wiki/images/8/8a/WinKVM-KVMForum2010.pdf)  
