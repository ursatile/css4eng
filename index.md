---
title: Home
layout: home
word_count: 77
---

# CSS for Engineers Course

## Course Modules

{% assign sorted_pages = site.pages | where_exp: "page", "page.path contains '.md'" | where_exp: "page", "page.title != 'Home'" | sort: "nav_order" %}

{% for page in sorted_pages %}
  {% if page.title and page.nav_order %}
<div class="module-item">
  <h3><a href="{{ page.url | relative_url }}">{{ page.title }}</a></h3>
  {% if page.excerpt %}
  <p class="module-summary">{{ page.excerpt | strip_html | truncate: 200 }}</p>
  {% endif %}
  {% if page.word_count %}
  <p class="word-count"><strong>Word Count:</strong> {{ page.word_count }}</p>
  {% endif %}
</div>
  {% endif %}
{% endfor %}

## Course Statistics

<div class="course-stats">
  {% assign total_words = 0 %}
  {% assign module_count = 0 %}
  {% for page in sorted_pages %}
    {% if page.word_count and page.nav_order %}
      {% assign total_words = total_words | plus: page.word_count %}
      {% assign module_count = module_count | plus: 1 %}
    {% endif %}
  {% endfor %}
  <p><strong>Total Modules:</strong> {{ module_count }}</p>
  <p><strong>Total Word Count:</strong> {{ total_words }}</p>
</div>



