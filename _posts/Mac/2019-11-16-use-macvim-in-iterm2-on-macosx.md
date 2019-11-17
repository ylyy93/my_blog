---
layout: post
title: Use MacVim in iterm2 on MacOSX
date: 2019-11-16 19:19 -0800
categories: Tech
tags: [Mac]
---

* Download [MacVim](https://macvim-dev.github.io/macvim/) and install.
* Open iterm2 and type `vim ~/.zshrc`.
* Add the following
```
# Macvim
alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim'
```
* In item2, try `mvim test.py`, then you will be able to see the highlight in the terminal! Hooray!
