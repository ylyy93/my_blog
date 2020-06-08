---
layout: post
title: When you update MacOSX
date: 2020-06-07 17:14 -0700
---

## Update bundler
```
sudo gem install bundler
bundle update --bundler
```


## Install command line tools
When you update your MacOSX,  your `/usr/include` was deleted again. The file `/Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg` does not exist. and
Xcode complains that command line tools are already installed  xcode-select --install
xcode-select: error: command line tools are already installed, use "Software Update" to install updates

```
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
```

## References

- [Can't compile C program on a Mac after upgrade to Mojave](https://stackoverflow.com/questions/52509602/cant-compile-c-program-on-a-mac-after-upgrade-to-mojave)
- [“Could not find bundler” error](https://stackoverflow.com/questions/6166081/could-not-find-bundler-error)
