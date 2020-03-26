---
layout: post
title: NLP - gensim (Topic modeling)
date: 2020-03-25 12:23 -0700
categories: Statistics
tags: [Machine Learning]
---


# Webclipss

* **Topic Modeling**: extract the underlying topics from large volumes of text. (e.g. LDA, LSI)
* Also, another significant advantage with `gensim` is: it lets you handle large text files without having to load the entire file in memory. (i.e., Gensim lets you read the text and update the dictionary, one line at a time, without loading the entire text file into system memory. )
* **NLP Jargon**: A ‘token’ typically means a ‘word’. A ‘document’ can typically refer to a ‘sentence’ or ‘paragraph’ and a ‘corpus’ is typically a ‘collection of documents as a bag of words’.

## What is dictionary and corpus, why they matter and where to use them?
* **Dictionary**: map each word to a unique id. (Use `corpora.Dictionary()`)
  * Used to create a 'bag of words' Corpus.
* **Corpus**: for each document, a corpus contains each word’s id and its frequency count in that document.
  * *Dictionary* and *Corpus* are used as inputs to topic modeling

How to create and work with dictionary and corpus?
How to load and work with text data from multiple text files in memory efficient way
Create topic models with LDA and interpret the outputs
Create TFIDF model, bigrams, trigrams, Word2Vec model, Doc2Vec model
Compute similarity metrics
