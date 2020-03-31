---
layout: post
title: Python NLP - Spacy
date: 2020-03-31 13:39 -0700
categories: Coding
tags: [Python, NLP]
---


## Install

```bash
pip install spacy
python3 -m spacy download en_core_web_sm
```

### Option 1
```python
import spacy
nlp = spacy.load("en_core_web_sm")           # load model package "en_core_web_sm"
doc = nlp("This is a sentence.")
```
### Option 2
```python
import en_core_sci_md
nlp = en_core_web_sm.load()
doc = nlp("This is a sentence.")
```

### Part-of-speech tagging

```python
doc = nlp("Apple is looking at buying U.K. startup for $1 billion.")
for token in doc:
    print(token.text, token.lemma_, token.pos_, token.tag_, token.dep_,
            token.shape_, token.is_alpha, token.is_stop)
```

### Noun chunks
```python
doc = nlp("Autonomous cars shift insurance liability toward manufacturers")
for chunk in doc.noun_chunks:
    print(chunk.text, chunk.root.text, chunk.root.dep_,
            chunk.root.head.text)
```

### Navigating the parse tree
```python
doc = nlp("Autonomous cars shift insurance liability toward manufacturers")
for token in doc:
    print(token.text, token.dep_, token.head.text, token.head.pos_,
            [child for child in token.children])
```
