---
layout: post
title: NLP - gensim (Topic modeling)
date: 2020-03-25 12:23 -0700
categories: Statistics
tags: [Machine Learning]
---

- [Gensim Tutorial – A Complete Beginners Guide](https://www.machinelearningplus.com/nlp/gensim-tutorial/)

# Webclipss

* **Topic Modeling**: extract the underlying topics from large volumes of text. (e.g. LDA, LSI)
* Also, another significant advantage with `gensim` is: it lets you handle large text files without having to load the entire file in memory. (i.e., Gensim lets you read the text and update the dictionary, one line at a time, without loading the entire text file into system memory. )
* **NLP Jargon**: A ‘token’ typically means a ‘word’. A ‘document’ can typically refer to a ‘sentence’ or ‘paragraph’ and a ‘corpus’ is typically a ‘collection of documents as a bag of words’.

## What is dictionary and corpus, why they matter and where to use them?
* **Dictionary**: map each word to a unique id. (Use `corpora.Dictionary()`)
  * Used to create a 'bag of words' Corpus.
* **Corpus**: for each document, a corpus contains each word’s id and its frequency count in that document.
  * *Dictionary* and *Corpus* are used as inputs to topic modeling

# Step 1: Create dictionary!
```python
import gensim
from gensim import corpora
from pprint import pprint

# How to create a dictionary from a list of sentences?
documents = ["The Saudis are preparing a report that will acknowledge that",
             "Saudi journalist Jamal Khashoggi's death was the result of an",
             "interrogation that went wrong, one that was intended to lead",
             "to his abduction from Turkey, according to two sources."]

documents_2 = ["One source says the report will likely conclude that",
                "the operation was carried out without clearance and",
                "transparency and that those involved will be held",
                "responsible. One of the sources acknowledged that the",
                "report is still being prepared and cautioned that",
                "things could change."]

# Tokenize(split) the sentences into words
texts = [[text for text in doc.split()] for doc in documents]

# Create dictionary
dictionary = corpora.Dictionary(texts)

# Get information about the dictionary
print(dictionary)
#> Dictionary(33 unique tokens: ['Saudis', 'The', 'a', 'acknowledge', 'are']...)
# Show the word to id map
print(dictionary.token2id)
#> {'Saudis': 0, 'The': 1, 'a': 2, 'acknowledge': 3, 'are': 4,
#> 'preparing': 5, 'report': 6, 'that': 7, 'will': 8, 'Jamal': 9,
#> "Khashoggi's": 10, 'Saudi': 11, 'an': 12, 'death': 13,
#> 'journalist': 14, 'of': 15, 'result': 16, 'the': 17, 'was': 18,
#> 'intended': 19, 'interrogation': 20, 'lead': 21, 'one': 22,
#> 'to': 23, 'went': 24, 'wrong,': 25, 'Turkey,': 26, 'abduction': 27,
#> 'according': 28, 'from': 29, 'his': 30, 'sources.': 31, 'two': 32}
documents_2 = ["The intersection graph of paths in trees",
               "Graph minors IV Widths of trees and well quasi ordering",
               "Graph minors A survey"]

texts_2 = [[text for text in doc.split()] for doc in documents_2]

# add document
dictionary.add_documents(texts_2)


# If you check now, the dictionary should have been updated with the new words (tokens).
print(dictionary)
#> Dictionary(45 unique tokens: ['Human', 'abc', 'applications', 'computer', 'for']...)

print(dictionary.token2id)
#> {'Human': 0, 'abc': 1, 'applications': 2, 'computer': 3, 'for': 4, 'interface': 5,
#>  'lab': 6, 'machine': 7, 'A': 8, 'of': 9, 'opinion': 10, 'response': 11, 'survey': 12,
#>  'system': 13, 'time': 14, 'user': 15, 'EPS': 16, 'The': 17, 'management': 18,
#>  'System': 19, 'and': 20, 'engineering': 21, 'human': 22, 'testing': 23, 'Relation': 24,
#>  'error': 25, 'measurement': 26, 'perceived': 27, 'to': 28, 'binary': 29, 'generation': 30,
#>  'random': 31, 'trees': 32, 'unordered': 33, 'graph': 34, 'in': 35, 'intersection': 36,
#>  'paths': 37, 'Graph': 38, 'IV': 39, 'Widths': 40, 'minors': 41, 'ordering': 42,
#>  'quasi': 43, 'well': 44}
```

## How to create a Dictionary from one or more text files?

### One file
```python
from gensim.utils import simple_preprocess
from smart_open import smart_open
import os

# Create gensim dictionary form a single tet file
dictionary = corpora.Dictionary(simple_preprocess(line, deacc=True) for line in open('sample.txt', encoding='utf-8'))

# Token to Id map
dictionary.token2id

#> {'according': 35,
#>  'and': 22,
#>  'appointment': 23,
#>  'army': 0,
#>  'as': 43,
#>  'at': 24,
#>   ...
#> }
```

### Multiple files
```python
class ReadTxtFiles(object):
    def __init__(self, dirname):
        self.dirname = dirname

    def __iter__(self):
        for fname in os.listdir(self.dirname):
            for line in open(os.path.join(self.dirname, fname), encoding='latin'):
                yield simple_preprocess(line)

path_to_text_directory = "lsa_sports_food_docs"

dictionary = corpora.Dictionary(ReadTxtFiles(path_to_text_directory))

# Token to Id map
dictionary.token2id
# {'across': 0,
#  'activity': 1,
#  'although': 2,
#  'and': 3,
#  'are': 4,
#  ...
# }
```

# Step 2: Create bag of words corpus !

```python
# List with 2 sentences
my_docs = ["Who let the dogs out?",
           "Who? Who? Who? Who?"]

# Tokenize the docs
tokenized_list = [simple_preprocess(doc) for doc in my_docs]

# Create the Corpus
mydict = corpora.Dictionary()
mycorpus = [mydict.doc2bow(doc, allow_update=True) for doc in tokenized_list]
pprint(mycorpus)
# > [[(0, 1), (1, 1), (2, 1), (3, 1), (4, 1)], [(4, 4)]]
# The (0, 1) in line 1 means, the word with id=0 appears once in the 1st document.
# Likewise, the (4, 4) in the second list item means the word with id 4 appears 4 times in the second document. And so on.
word_counts = [[(mydict[id], count) for id, count in line] for line in mycorpus]
pprint(word_counts)
#> [[('dogs', 1), ('let', 1), ('out', 1), ('the', 1), ('who', 1)], [('who', 4)]]
```

```python
from gensim.utils import simple_preprocess
from smart_open import smart_open
import nltk
nltk.download('stopwords')  # run once
from nltk.corpus import stopwords
stop_words = stopwords.words('english')


class BoWCorpus(object):
    def __init__(self, path, dictionary):
        self.filepath = path
        self.dictionary = dictionary

    def __iter__(self):
        global mydict  # OPTIONAL, only if updating the source dictionary.
        for line in smart_open(self.filepath, encoding='latin'):
            # tokenize
            tokenized_list = simple_preprocess(line, deacc=True)

            # create bag of words
            bow = self.dictionary.doc2bow(tokenized_list, allow_update=True)

            # update the source dictionary (OPTIONAL)
            mydict.merge_with(self.dictionary)

            # lazy return the BoW
            yield bow


# Create the Dictionary
mydict = corpora.Dictionary()

# Create the Corpus
bow_corpus = BoWCorpus('sample.txt', dictionary=mydict)  # memory friendly

# Print the token_id and count for each line.
for line in bow_corpus:
    print(line)

#> [(0, 1), (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1), (8, 1), (9, 1), (10, 1), (11, 1)]
#> [(12, 1), (13, 1), (14, 1), (15, 1), (16, 1), (17, 1)]
#> ... truncated ...

```


```python
# Save the Dict and Corpus
mydict.save('mydict.dict')  # save dict to disk
corpora.MmCorpus.serialize('bow_corpus.mm', bow_corpus)  # save corpus to disk
# Load them back
loaded_dict = corpora.Dictionary.load('mydict.dict')

corpus = corpora.MmCorpus('bow_corpus.mm')
for line in corpus:
    print(line)
```

```python
from gensim import models
import numpy as np

documents = ["This is the first line",
             "This is the second sentence",
             "This third document"]

# Create the Dictionary and Corpus
mydict = corpora.Dictionary([simple_preprocess(line) for line in documents])
corpus = [mydict.doc2bow(simple_preprocess(line)) for line in documents]

# Show the Word Weights in Corpus
for doc in corpus:
    print([[mydict[id], freq] for id, freq in doc])

# [['first', 1], ['is', 1], ['line', 1], ['the', 1], ['this', 1]]
# [['is', 1], ['the', 1], ['this', 1], ['second', 1], ['sentence', 1]]
# [['this', 1], ['document', 1], ['third', 1]]

# Create the TF-IDF model
tfidf = models.TfidfModel(corpus, smartirs='ntc')

# Show the TF-IDF weights
for doc in tfidf[corpus]:
    print([[mydict[id], np.around(freq, decimals=2)] for id, freq in doc])
# [['first', 0.66], ['is', 0.24], ['line', 0.66], ['the', 0.24]]
# [['is', 0.24], ['the', 0.24], ['second', 0.66], ['sentence', 0.66]]
# [['document', 0.71], ['third', 0.71]]
```

```python

import gensim.downloader as api

# Get information about the model or dataset
api.info('glove-wiki-gigaword-50')
# {'base_dataset': 'Wikipedia 2014 + Gigaword 5 (6B tokens, uncased)',
#  'checksum': 'c289bc5d7f2f02c6dc9f2f9b67641813',
#  'description': 'Pre-trained vectors based on Wikipedia 2014 + Gigaword, 5.6B tokens, 400K vocab, uncased (https://nlp.stanford.edu/projects/glove/).',
#  'file_name': 'glove-wiki-gigaword-50.gz',
#  'file_size': 69182535,
#  'license': 'http://opendatacommons.org/licenses/pddl/',
#  (... truncated...)

# Download
w2v_model = api.load("glove-wiki-gigaword-50")
w2v_model.most_similar('blue')
# [('red', 0.8901656866073608),
#  ('black', 0.8648407459259033),
#  ('pink', 0.8452916741371155),
#  ('green', 0.8346816301345825),
#  ... ]
```

```python
dataset = api.load("text8")
dataset = [wd for wd in dataset]

dct = corpora.Dictionary(dataset)
corpus = [dct.doc2bow(line) for line in dataset]

# Build the bigram models
bigram = gensim.models.phrases.Phrases(dataset, min_count=3, threshold=10)

# Construct bigram
print(bigram[dataset[0]])
# ['anarchism', 'originated', 'as', 'a', 'term', 'of', 'abuse', 'first', 'used',
#  'against', 'early', 'working_class', 'radicals', 'including', 'the', 'diggers',
#  'of', 'the', 'english', 'revolution', 'and', 'the', 'sans_culottes', 'of', 'the',
#  'french_revolution', 'whilst',...]

```

```python
# Build the trigram models
trigram = gensim.models.phrases.Phrases(bigram[dataset], threshold=10)

# Construct trigram
print(trigram[bigram[dataset[0]]])

```

# Step 3: Create topic models !

```python
# Step 0: Import packages and stopwords
from gensim.models import LdaModel, LdaMulticore
import gensim.downloader as api
from gensim.utils import simple_preprocess, lemmatize
from nltk.corpus import stopwords
import re
import logging
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s')
logging.root.setLevel(level=logging.INFO)
stop_words = stopwords.words('english')
stop_words = stop_words + ['com', 'edu', 'subject', 'lines', 'organization', 'would', 'article', 'could']
# Step 1: Import the dataset and get the text and real topic of each news article
dataset = api.load("text8")
data = [d for d in dataset]
# Step 2: Prepare Data (Remove stopwords and lemmatize)
data_processed = []

for i, doc in enumerate(data[:100]):
    doc_out = []
    for wd in doc:
        if wd not in stop_words:  # remove stopwords
            lemmatized_word = lemmatize(wd, allowed_tags=re.compile('(NN|JJ|RB)'))  # lemmatize
            if lemmatized_word:
                doc_out = doc_out + [lemmatized_word[0].split(b'/')[0].decode('utf-8')]
        else:
            continue
    data_processed.append(doc_out)

# Print a small sample    
print(data_processed[0][:5])
#> ['anarchism', 'originated', 'term', 'abuse', 'first']
# Step 3: Create the Inputs of LDA model: Dictionary and Corpus
dct = corpora.Dictionary(data_processed)
corpus = [dct.doc2bow(line) for line in data_processed]
# Step 4: Train the LDA model
lda_model = LdaMulticore(corpus=corpus,
                         id2word=dct,
                         random_state=100,
                         num_topics=7,
                         passes=10,
                         chunksize=1000,
                         batch=False,
                         alpha='asymmetric',
                         decay=0.5,
                         offset=64,
                         eta=None,
                         eval_every=0,
                         iterations=100,
                         gamma_threshold=0.001,
                         per_word_topics=True)

# save the model
lda_model.save('lda_model.model')
# See the topics
lda_model.print_topics(-1)
# [(0, '0.001*"also" + 0.000*"first" + 0.000*"state" + 0.000*"american" + 0.000*"time" + 0.000*"book" + 0.000*"year" + 0.000*"many" + 0.000*"person" + 0.000*"new"'),
#  (1, '0.001*"also" + 0.001*"state" + 0.001*"ammonia" + 0.000*"first" + 0.000*"many" + 0.000*"american" + 0.000*"war" + 0.000*"time" + 0.000*"year" + 0.000*"name"'),
#  (2, '0.005*"also" + 0.004*"american" + 0.004*"state" + 0.004*"first" + 0.003*"year" + 0.003*"many" + 0.003*"time" + 0.003*"new" + 0.003*"war" + 0.003*"person"'),
#  (3, '0.001*"atheism" + 0.001*"also" + 0.001*"first" + 0.001*"atheist" + 0.001*"american" + 0.000*"god" + 0.000*"state" + 0.000*"many" + 0.000*"new" + 0.000*"year"'),
#  (4, '0.001*"state" + 0.001*"also" + 0.001*"many" + 0.000*"world" + 0.000*"agave" + 0.000*"time" + 0.000*"new" + 0.000*"war" + 0.000*"god" + 0.000*"person"'),
#  (5, '0.001*"also" + 0.001*"abortion" + 0.001*"first" + 0.001*"american" + 0.000*"state" + 0.000*"many" + 0.000*"year" + 0.000*"time" + 0.000*"war" + 0.000*"person"'),
#  (6, '0.005*"also" + 0.004*"first" + 0.003*"time" + 0.003*"many" + 0.003*"state" + 0.003*"world" + 0.003*"american" + 0.003*"person" + 0.003*"apollo" + 0.003*"language"')]

```
How to load and work with text data from multiple text files in memory efficient way
Create topic models with LDA and interpret the outputs
Create `TFIDF` model, bigrams, trigrams, `Word2Vec` model, `Doc2Vec` model
Compute similarity metrics
