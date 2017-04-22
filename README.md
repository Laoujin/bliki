pongit.be
=========

```
# setup:
gem install jekyll bundler

# run:
npm start
bundle exec jekyll serve --drafts

# Show theme path
bundle show minima

# New plugin
# Add to _config.yml and Gemfile
bundle install
```

TODO: posts: add tags
TODO: About: 2 content panes


https://github.com/jekyll/github-metadata#authentication
JEKYLL_GITHUB_TOKEN=123abc [bundle exec] jekyll serve
https://help.github.com/articles/adding-jekyll-plugins-to-a-github-pages-site/
https://jekyllrb.com/docs/plugins/

Liquid
------
https://help.shopify.com/themes/liquid
https://github.com/Shopify/liquid/wiki/Liquid-for-Designers


**Keyboard Glyphs**:  
BUG: Shortcut containing a + or ,


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

