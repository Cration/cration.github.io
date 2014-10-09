---
layout: post
title: "在sublime text中编辑FTP上的文档"
description: "　　本文介绍了在sublime text中使用FTP插件进行远程编辑的配置方法。"
category: "work"
tags: [ftp, sublime text]
---
{% include JB/setup %}

　　在工作过程中，我们有时需要编辑远程服务器上的文档，常用的方法是：

>* 从服务器上下载文档  
* 编辑文档  
* 上传文档到服务器  

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

　　搭建好FTP服务器后，可以通过浏览器或资源管理器测试FTP是否正常，此处不再演示。

###sublime text中安装FTP插件

　　接下来是按照sublime text的FTP插件，首先按下“ctrl+shift+P”，输入install，稍等片刻后在弹出的输入框内输入SFTP，选择“SFTP”插件进行安装。当然，首先要确认已经安装了sublime text的插件管理器，安装方法参见[这里](https://sublime.wbond.net/installation)。

　　sublime text 2 的插件管理安装代码：

{% highlight python %}
import urllib2,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' + 'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler()) ); by = urllib2.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); open( os.path.join( ipp, pf), 'wb' ).write(by) if dh == h else None; print('Error validating download (got %s instead of %s), please try manual install' % (dh, h) if dh != h else 'Please restart Sublime Text to finish installation')
{% endhighlight %}

　　Sublime text 3 的插件管理安装代码：

{% highlight python %}
import urllib.request,os,hashlib; h = '7183a2d3e96f11eeadd761d777e62404' + 'e330c659d4bb41d3bdf022e94cab3cd0'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
{% endhighlight %}

　　SFTP插件安装完成后，File菜单中会出现“SFTP/FTP”的选项。如下图：

![File菜单]({{site.img_path}}/sublime_text_sftp_1.png)

###配置FTP插件

　　接下来是配置插件。先下载文档的文件夹并用sublime text打开，右击文件夹，选择“SFTP/FTP”→“Map to Remote...”。

![File菜单]({{site.img_path}}/sublime_text_sftp_2.png)

　　此时会弹出一个sftp-config.json的配置文件，我们可以根据需要修改其中的配置选项，默认选项如下：

{% highlight json %}
{
    // The tab key will cycle through the settings when first created
    // Visit http://wbond.net/sublime_packages/sftp/settings for help
    
    // sftp, ftp or ftps
    "type": "sftp",

    "save_before_upload": true,
    "upload_on_save": false,
    "sync_down_on_open": false,
    "sync_skip_deletes": false,
    "sync_same_age": true,
    "confirm_downloads": false,
    "confirm_sync": true,
    "confirm_overwrite_newer": false,
    
    "host": "example.com",
    "user": "username",
    //"password": "password",
    //"port": "22",
    
    "remote_path": "/example/path/",
    "ignore_regexes": [
        "\\.sublime-(project|workspace)", "sftp-config(-alt\\d?)?\\.json",
        "sftp-settings\\.json", "/venv/", "\\.svn/", "\\.hg/", "\\.git/",
        "\\.bzr", "_darcs", "CVS", "\\.DS_Store", "Thumbs\\.db", "desktop\\.ini"
    ],
    //"file_permissions": "664",
    //"dir_permissions": "775",
    
    //"extra_list_connections": 0,

    "connect_timeout": 30,
    //"keepalive": 120,
    //"ftp_passive_mode": true,
    //"ftp_obey_passive_host": false,
    //"ssh_key_file": "~/.ssh/id_rsa",
    //"sftp_flags": ["-F", "/path/to/ssh_config"],
    
    //"preserve_modification_times": false,
    //"remote_time_offset_in_hours": 0,
    //"remote_encoding": "utf-8",
    //"remote_locale": "C",
    //"allow_config_upload": false,
}
{% endhighlight %}

　　以下是我的配置文件，注意到，匿名用户的用户名和密码都是“anonymous”。

{% highlight json %}
{
    // The tab key will cycle through the settings when first created
    // Visit http://wbond.net/sublime_packages/sftp/settings for help
    
    // sftp, ftp or ftps
    "type": "ftp",                  //根据服务器的协议类型选择

    "save_before_upload": true,
    "upload_on_save": true,         //保存文件时自动上传
    "sync_down_on_open": false,
    "sync_skip_deletes": false,
    "sync_same_age": true,
    "confirm_downloads": false,
    "confirm_sync": true,
    "confirm_overwrite_newer": false,
    
    "host": "192.168.4.146",    //FTP地址
    "user": "anonymous",
    "password": "anonymous",
    //"port": "22",
    
    "remote_path": "/",         //这里填写FTP服务器上对应的文件夹路径，记得修改
    "ignore_regexes": [
        "\\.sublime-(project|workspace)", "sftp-config(-alt\\d?)?\\.json",
        "sftp-settings\\.json", "/venv/", "\\.svn/", "\\.hg/", "\\.git/",
        "\\.bzr", "_darcs", "CVS", "\\.DS_Store", "Thumbs\\.db", "desktop\\.ini"
    ],
    //"file_permissions": "664",
    //"dir_permissions": "775",
    
    //"extra_list_connections": 0,

    "connect_timeout": 30,
    //"keepalive": 120,
    //"ftp_passive_mode": true,
    //"ftp_obey_passive_host": false,
    //"ssh_key_file": "~/.ssh/id_rsa",
    //"sftp_flags": ["-F", "/path/to/ssh_config"],
    
    //"preserve_modification_times": false,
    //"remote_time_offset_in_hours": 0,
    //"remote_encoding": "utf-8",
    //"remote_locale": "C",
    //"allow_config_upload": false,
}
{% endhighlight %}
