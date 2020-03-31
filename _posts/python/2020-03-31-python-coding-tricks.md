---
layout: post
title: Python Coding Tricks
date: 2020-03-31 14:04 -0700
categories: Coding
tags: [Python]
---

## Progress Bar by `tqdm`

Example:
```python
from tqdm import tqdm
import time

text = ""
for char in tqdm(["a", "b", "c", "d"]):
    time.sleep(0.25)
    text = text + char
```
