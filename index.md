---
layout: page
title: Summer Coral
subtitle: hehe
---
{% include JB/setup %}

## Articles

<ul class="posts">
  {% for post in site.posts %}
    {% include post_item.html  %}
  {% endfor %}
</ul>

### Under construction

![建设中]({{ site.img_path }}/UnderConstructionPage.gif)
