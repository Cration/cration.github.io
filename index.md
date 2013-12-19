---
layout: page
title: Summer Coral
---
{% include JB/setup %}

View at [github.com](http://github.com/Cration/cration.github.io)

## Articles

<ul class="posts">
  {% for post in site.posts %}
    <li><span>{{ post.date | date_to_string }}</span> &raquo; <a href="{{ BASE_PATH }}{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>

## Under construction

This blog is still under construction.


