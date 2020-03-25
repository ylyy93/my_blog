---
layout: post
title: Python - tricks (MAC OSX)
date: 2020-03-25 10:45 -0700
categories: Coding
tags: [Python]
---

# Downgrade packages
```bash
pip show numpy
pip install -U numpy==1.12.0
```

# Set python alias (default 3.x)
In `~/.bashrc`
```bash
alias python=/usr/local/bin/python3
```

# Check where pip is installing the modules
```bash
which -a pip
```

# Solving `urllib and “SSL: CERTIFICATE_VERIFY_FAILED” Error`

```bash
pip install certifi
/Applications/Python\ 3.8/Install\ Certificates.command
```
