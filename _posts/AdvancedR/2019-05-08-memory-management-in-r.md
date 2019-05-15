---
layout: post
title: Memory Management in R
date: 2019-05-08 14:00 -0600
categories: Tech
tags: [R]
---

- `object_size()`:

### R package `pryr`
- `mem_used()`, `mem_change()`: how R allocate and free memory
### R package `lineprof`
- how memory is allocated and released in larger code blocks.
- `address()` or `refs()`: how R modifies in place or modifies a copy.

首先打开一个interactive session。
```
sinteractive --partition=shas --qos=normal --time=01:00:00 --ntasks=6 --nodes=1 --mem=0
```
其中，
`ntasks` 决定了每个node上可以并行的task个数。只有当其大于一，`Rmpi`才能work。


check memory of node `shas0208` in Megabytes
```
sinfo -Nel -n shas0208
```
