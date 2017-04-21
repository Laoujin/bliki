pongit.be
=========

```
# setup:
gem install jekyll bundler

# run:
bundle exec jekyll serve

# Show theme path
bundle show minima
```

Kramdown tutorial
-----------------

```md
# Images:
![My helpful screenshot]({{ site.url }}/assets/screenshot.jpg)


# Links:
```
[description][link-slug]
[link-slug]: https://github.com

{% highlight ruby linenos %}
{% endhighlight %}

{::options parse_block_html="true" /}
<pre># yaye</pre>
{::options parse_block_html="false" /}

{% for my_page in site.pages %}
	{% if my_page.title %}
		<a class="page-link" href="{{ my_page.url | relative_url }}">{{ my_page.title | escape }}</a>
	{% endif %}
{% endfor %}
```

TODO
----
https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/

