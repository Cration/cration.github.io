---
layout: page
title: Summer Coral
---
{% include JB/setup %}

## Articles

<ul class="posts">
    {% for post in site.posts %}
        {% capture summary %}{{post.content | split:'<!--more-->' | first }}{% endcapture%}
        <li class="post">
            <span class="date">{{ post.date | date_to_string  }}</span> &raquo;
            <a class="title" href="{{ site.url }}{{ post.url }}">{{post.title }}</a>
            {{ summary }}
        </li>
    {% endfor %}
</ul>


### Under construction

![建设中]({{ site.img_path }}/UnderConstructionPage.gif)

