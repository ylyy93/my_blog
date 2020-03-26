---
layout: post
title: Word Embedding (Word vector models)
date: 2020-03-24 15:02 -0700
categories: Statistics
tags: [Machine Learning]
---

# Webclips

* **Word Embedding**: vector representations of a particular word.
* [`Word2Vec`](https://arxiv.org/pdf/1310.4546.pdf)
  * Idea: have words with similar context occupy close spatial positions.
  * Method 1: Skip Gram - Small data, represent rare words wells
  * Method 2: Common Bag of Words (CBOW) - faster, better representation for more frequent words
  * Advanced: Hierarchical Softmax and Skip-Gram Negative Sampling
* `FastText`
