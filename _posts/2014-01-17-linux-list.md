---
layout: post
title: "Linux内核中的双向链表"
description: "　　简要介绍了linux内核中的双向链表实现。"
category: "program"
tags: [linux, list, 数据结构, C, 编程技巧]
---
{% include JB/setup %}

　　Linux内核中实现了一个通用的[双向链表](https://github.com/torvalds/linux/blob/master/include/linux/list.h)，其实现极其简洁而优雅。

　　先来看看数据结构的定义：

{% highlight C %}
struct list_head{
    struct list_head *next, *prev;
};
{% endhighlight %}

　　和正常的双向链表一样，包含了一个prev和next指针。但是，正常的双向链表还会有数据域，这里却没有。这正是linux中list实现的优雅之处：不是在list中包含数据，而是在其他数据结构中包含list，从而实现list的通用性，而不用针对每一种数据结构实现不同的链表。

　　需要使用到list功能时，只需要在当前数据结构中加入struct list_head作为一个成员，就可以使用list的所有特性。list的许多功能都是通过宏定义的，比如最重要的list_entry，list_entry的功能是，通过list的地址和包含list的结构体类型，获取包含list的结构体的首地址。从而实现从list到外部数据结构的逆向访问。实现如下。

{% highlight C %}
/**
 * list_entry - get the struct for this entry
 * @ptr:        the &struct list_head pointer.
 * @type:        the type of the struct this is embedded in.
 * @member:        the name of the list_struct within the struct.
 */
#define list_entry(ptr, type, member) \
        container_of(ptr, type, member)
{% endhighlight %}

　　只是简单地将list_entry替换为container_of而已，再来看看container_of的实现：

{% highlight C %}
#ifndef container_of
/**
 * container_of - cast a member of a structure out to the containing structure
 * @ptr:        the pointer to the member.
 * @type:        the type of the container struct this is embedded in.
 * @member:        the name of the member within the struct.
 *
 */
#define container_of(ptr, type, member) ({                        \
        const typeof(((type *)0)->member) * __mptr = (ptr);        \
        (type *)((char *)__mptr - offsetof(type, member)); })
#endif
{% endhighlight %}

　　这里有两个重要的组成：typeof和offsetof，其中typeof是gcc的一个扩展特性，可以在编译时获取变量的类型。而offsetof的实现十分巧妙：

{% highlight C %}
#ifndef offsetof
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#endif
{% endhighlight %}

　　将一个NULL作为结构体的指针，从而计算出成员在结构体内部的偏移。NULL虽然是空指针，但是没有对其进行解引用的话，是不会引发错误的。通过在0x00000000处构造一个虚拟的结构体变量，从而计算成员在结构体中的偏移量，的确是非常tricky的方法，不过很实用。

　　不过这里还有一点疑问：为何container_of宏中需要用一个临时的__mptr常量来保存ptr的值，而不是直接用ptr进行计算？若直接使用ptr，也仅仅引用了一次，所以不会出现自增自减操作的错误。如果是想要起到检查输入的作用，即防止传入的member不是结构体的成员，那也说不通，因为offsetof宏也能起到相同的作用。<s>待考证。</s>

　　2014年01月18日更新：__mptr可以起到类型检查的作用，若传入的ptr不是member类型的指针，则会给出警告。

###References

[深入分析Linux内核链表](http://www.ibm.com/developerworks/cn/linux/kernel/l-chain/)
