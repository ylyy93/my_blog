---
layout: post
title: Python NLP - LDA Topic Modeling
date: 2020-03-29 22:56 -0700
categories: Statistics
tags: [Machine Learning, Python, NLP]
---

# Example: Kaggle COVID-19 Competition
Please refer to the [notebook](https://ylyy93.github.io/my_blog/assets/posts/kaggle/topic-modeling-finding-related-articles.html).

# Latent Dirichlet Allocation

| Notation | Description|
|----------|------------|
|N         |# words     |
|M         |# documents |
|V         |# vocabulary|
|K         |# topics    |

![LDA](https://ylyy93.github.io/my_blog/assets/posts/kaggle/LDA_notes.jpeg).

- [Latent Dirichlet Allocation](http://www.jmlr.org/papers/volume3/blei03a/blei03a.pdf)

## Preprocessing - Generate $M\times V$ Dummy Matrix (Input for LDA)
For preprocessing we use [scispaCy](https://allenai.github.io/scispacy/), which is a Python package containing [spaCy](https://spacy.io) models (Industrial-Strength Natural Language Processing in Python) for processing biomedical, scientific or clinical text.

```python
# parser
import scispacy
import spacy
import en_core_sci_md # Download: python3 -m spacy download en_core_web_sm
from tqdm import tqdm

# vectorizer and LDA
from sklearn.feature_extraction import text
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.decomposition import LatentDirichletAllocation
from scipy.spatial.distance import jensenshannon
```

###### Load Spacy Tokenizer  
```python
nlp = en_core_sci_md.load(disable=["tagger", "parser", "ner"])
nlp.max_length = 2000000

def spacy_tokenizer(sentence):
    return [word.lemma_ for word in nlp(sentence) if not (word.like_num or word.is_stop or word.is_punct or word.is_space or len(word)==1)]

# New stop words list
customize_stop_words = [
    'doi', 'preprint', 'copyright', 'peer', 'reviewed', 'org', 'https', 'et', 'al', 'author', 'figure',
    'rights', 'reserved', 'permission', 'used', 'using', 'biorxiv', 'fig', 'fig.', 'al.',
    'di', 'la', 'il', 'del', 'le', 'della', 'dei', 'delle', 'una', 'da',  'dell',  'non', 'si'
]

# Mark them as stop words
for w in customize_stop_words:
    nlp.vocab[w].is_stop = True
```

###### Tokenization - ($M\times V$ Dummy Matrix `data_vectorized`)
```python
vectorizer = CountVectorizer(tokenizer = spacy_tokenizer, max_features=800000) # V = 800000
data_vectorized = vectorizer.fit_transform(tqdm(all_texts))
```
###### Visualize tokenized data
```python
import pandas as pd
# most frequent words
word_count = pd.DataFrame({'word': vectorizer.get_feature_names(), 'count': np.asarray(data_vectorized.sum(axis=0))[0]})

word_count.sort_values('count', ascending=False).set_index('word')[:20].sort_values('count', ascending=True).plot(kind='barh')
```

## LDA
```python
lda = LatentDirichletAllocation(n_components=50, random_state=0) # K = 50 (# topics)
lda.fit(data_vectorized)
```

## Results

### Topic Discovery
```python
def print_top_words(model, vectorizer, n_top_words):
    feature_names = vectorizer.get_feature_names()
    for topic_idx, topic in enumerate(model.components_):
        message = "\nTopic #%d: " % topic_idx
        message += " ".join([feature_names[i]
                             for i in topic.argsort()[:-n_top_words - 1:-1]])
        print(message)
    print()
print_top_words(lda, vectorizer, n_top_words=25)
```

### $M\times K$ Probability Matrix (Output of LDA)
```python
doc_topic_dist = pd.DataFrame(lda.transform(data_vectorized))
```

### Get Nearest Papers - using Jensen-Shannon Divergence in Topic Space

```python
is_covid19_article = df.body_text.str.contains('COVID-19|SARS-CoV-2|2019-nCov|SARS Coronavirus 2|2019 Novel Coronavirus')
def get_k_nearest_docs(doc_dist, k=5, lower=1950, upper=2020, only_covid19=False, get_dist=False):
    '''
    doc_dist: topic distribution (sums to 1) of one article

    Returns the index of the k nearest articles (as by Jensen–Shannon divergence in topic space).
    '''

    relevant_time = df.publish_year.between(lower, upper)

    if only_covid19:
        temp = doc_topic_dist[relevant_time & is_covid19_article]

    else:
        temp = doc_topic_dist[relevant_time]

    distances = temp.apply(lambda x: jensenshannon(x, doc_dist), axis=1)
    k_nearest = distances[distances != 0].nsmallest(n=k).index

    if get_dist:
        k_distances = distances[distances != 0].nsmallest(n=k)
        return k_nearest, k_distances
    else:
        return k_nearest
```

### Search related papers to a chosen one
```python
def recommendation(paper_id, k=5, lower=1950, upper=2020, only_covid19=False):
    '''
    Returns the title of the k papers that are closest (topic-wise) to the paper given by paper_id.
    '''

    print(df.title[df.paper_id == paper_id].values[0])

    recommended, dist = get_k_nearest_docs(doc_topic_dist[df.paper_id == paper_id].iloc[0], k, lower, upper, only_covid19, get_dist=True)
    recommended = df.iloc[recommended].copy()
    recommended['similarity'] = 1 - dist

    h = '<br/>'.join(['<a href="' + l + '" target="_blank">'+ n + '</a>' +' (Similarity: ' + "{:.2f}".format(s) + ')' for l, n, s in recommended[['url','title', 'similarity']].values])
    display(HTML(h))
```

```python
recommendation('a137eb51461b4a4ed3980aa5b9cb2f2c1cf0292a', k=5, plot_dna=True)
```

### Search related papers related to a statement

```python
def relevant_articles(tasks, k=3, lower=1950, upper=2020, only_covid19=False):
    tasks = [tasks] if type(tasks) is str else tasks

    tasks_vectorized = vectorizer.transform(tasks)
    tasks_topic_dist = pd.DataFrame(lda.transform(tasks_vectorized))

    for index, bullet in enumerate(tasks):
        print(bullet)
        recommended = get_k_nearest_docs(tasks_topic_dist.iloc[index], k, lower, upper, only_covid19)
        recommended = df.iloc[recommended]

        h = '<br/>'.join(['<a href="' + l + '" target="_blank">'+ n + '</a>' for l, n in recommended[['url','title']].values])
        display(HTML(h))
```

```python
task1 = ["Range of incubation periods for the disease in humans (and how this varies across age and health status) and how long individuals are contagious, even after recovery.",
"Prevalence of asymptomatic shedding and transmission (e.g., particularly children).",
"Seasonality of transmission."]
tasks={'What is known about transmission, incubation, and environmental stability?': task1}
relevant_articles(task1, 5, only_covid19=True)
```
