---
layout: post
title:  "Deploy a website on Gibhub with Jekyll"
date:   2019-03-31 12:27:57 -0600
categories: Tech
tags: [jekyll]
---

## Create a new website
{% highlight ruby %}
jekyll new my_blog
cd my_blog
bundle exec jekyll serve
{% endhighlight %}

## Deploy a website on github
First, create a new repository `my_blog` on Github without creating README file.

Then, modify the `_config.yml` file in the folder my_blog.

{% highlight ruby %}
cd my_blog/
vim _config.yml
{% endhighlight %}

Change `baseurl` to

{% highlight ruby %}
baseurl: "/my_blog"
{% endhighlight %}

{% highlight ruby %}
git init
git checkout -b gh-pages
git status
git add .
git commit -m "initial commit"
git remote add origin https://github.com/ylyy93/my_blog.git
git push origin gh-pages
{% endhighlight %}

If the [permission is denied][denied-permission] (due to multiple github accounts), try the following. You might be asked to enter your github account password.

{% highlight ruby %}
git config -l | grep url
git remote set-url origin "https://ylyy93@github.com/ylyy93/my_blog.git"
git config -l | grep url
git push origin gh-pages
{% endhighlight %}

## Update your Website

Create a `deploy.sh` file under `my_blog` and copy and paste the following code.

{% highlight ruby %}
#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
bundle exec jekyll build

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin gh-pages
{% endhighlight %}

Run the following chunk every time you make changes to your website.
{% highlight ruby %}
./deploy.sh
{% endhighlight %}

If you want to check out your website locally and debug, use
{% highlight ruby %}
bundle exec jekyll serve
{% endhighlight %}


Check out the [awesome tutorial ][awesome-tutorial] on Youtube.

[awesome-tutorial]: https://www.youtube.com/watch?v=fqFjuX4VZmU&list=PLLAZ4kZ9dFpOPV5C5Ay0pHaa0RJFhcmcB&index=19
[denied-permission]: https://www.a2hosting.com/kb/developer-corner/version-control-systems1/403-forbidden-error-message-when-you-try-to-push-to-a-github-repository
