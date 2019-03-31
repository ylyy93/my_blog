---
layout: post
title:  "Welcome to Jekyll!"
date:   2019-03-31 12:27:57 -0600
categories: jekyll update
---

## Create a new website
{% highlight ruby %}
jekyll new my_blog
cd my_blog
bundle exec jekyll serve
{% endhighlight %}

## Deploy a website on github

{% highlight ruby %}
cd my_blog/
vim _config.yml
{% endhighlight %}
Change baseurl to
{% highlight ruby %}
baseurl: "my_blog"
{% endhighlight %}



Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/
