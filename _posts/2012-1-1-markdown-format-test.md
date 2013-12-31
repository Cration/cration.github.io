---
layout: post
title: "Markdown format test"
description: ""
category: ""
tags: []
---
{% include JB/setup %}

　　markdown格式测试所用。

<!--more-->

{% highlight python %}
python
@requires_authorization
def somefunc(param1='', param2=0):
    '''A docstring'''
    if param1 > param2: # interesting
        print 'Greater'
    return (param2 - param1 + 1) or None

class SomeClass:
    pass

>>> message = '''interpreter
... prompt'''
{% endhighlight %}

  
$$f(x_1,x_x,\ldots,x_n) = x_1^2 + x_2^2 + \cdots + x_n^2 $$
  
