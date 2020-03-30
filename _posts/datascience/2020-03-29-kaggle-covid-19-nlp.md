---
layout: post
title: Kaggle - COVID-19 NLP
date: 2020-03-29 18:43 -0700
categories: Statistics
tags: [Machine Learning, Python, NLP]
---

## Preliminary
```python
import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import glob
import json

import matplotlib.pyplot as plt
plt.style.use('ggplot')
```

## Load Metadata

```python
root_path = 'CORD-19-research-challenge/'
metadata_path = f'{root_path}/metadata.csv'
meta_df = pd.read_csv(metadata_path, dtype={
    'pubmed_id': str,
    'Microsoft Academic Paper ID': str,
    'doi': str
})
meta_df.info()
```

```bash
<class 'pandas.core.frame.DataFrame'>
RangeIndex: 44220 entries, 0 to 44219
Data columns (total 15 columns):
 #   Column                       Non-Null Count  Dtype
---  ------                       --------------  -----
 0   sha                          28462 non-null  object
 1   source_x                     44220 non-null  object
 2   title                        43996 non-null  object
 3   doi                          40750 non-null  object
 4   pmcid                        23319 non-null  object
 5   pubmed_id                    22943 non-null  object
 6   license                      44220 non-null  object
 7   abstract                     35806 non-null  object
 8   publish_time                 34197 non-null  object
 9   authors                      41074 non-null  object
 10  journal                      33173 non-null  object
 11  Microsoft Academic Paper ID  964 non-null    object
 12  WHO #Covidence               1767 non-null   object
 13  has_full_text                44220 non-null  bool
 14  full_text_file               32829 non-null  object
dtypes: bool(1), object(14)
memory usage: 4.8+ MB
```


## Load Json files

Get path to all JSON files:
```python
all_json = glob.glob(f'{root_path}/**/*.json', recursive=True)
len(all_json)
all_json[0]
# 'CORD-19-research-challenge/biorxiv_medrxiv/biorxiv_medrxiv/0015023cc06b5362d332b3baf348d11567ca2fbb.json'
```

### Data Exploration
The Json file contains ['paper_id', 'metadata', 'abstract', 'body_text', 'bib_entries',
'ref_entries', 'back_matter'].

#### Json file
```python
# tmp is a dictionary, with 7 keys.
tmp = json.load(open(all_json[0]))
tmp.keys()
# dict_keys(['paper_id', 'metadata', 'abstract', 'body_text', 'bib_entries',
# 'ref_entries', 'back_matter'])
```

```python
tmp["paper_id"] # '0015023cc06b5362d332b3baf348d11567ca2fbb'
tmp["metadata"] # authors and title
tmp["abstract"]
"""
>>> pprint(tmp["abstract"])
[{'cite_spans': [],
  'ref_spans': [],
  'section': 'Abstract',
  'text': 'word count: 194 22 Text word count: 5168 23 24 25 author/funder. '
          'All rights reserved. No reuse allowed without permission. Abstract '
          '27 The positive stranded RNA genomes of picornaviruses comprise a '
          'single large open reading 28 frame flanked by 5′ and 3′ '
          'untranslated regions (UTRs). Foot-and-mouth disease virus (FMDV) 29 '
          'has an unusually large 5′ UTR (1.3 kb) containing five structural '
          'domains. These include the 30 internal ribosome entry site (IRES), '
          'which facilitates initiation of translation, and the cis-acting 31 '
          'replication element (cre). Less well characterised structures are a '
          '5′ terminal 360 nucleotide 32 stem-loop, a variable length '
          'poly-C-tract of approximately 100-200 nucleotides and a series of '
          '33 two to four tandemly repeated pseudoknots (PKs). We investigated '
          'the structures of the PKs 34 by selective 2′ hydroxyl acetylation '
          'analysed by primer extension (SHAPE) analysis and 35 determined '
          'their contribution to genome replication by mutation and deletion '
          'experiments. 36 SHAPE and mutation experiments confirmed the '
          'importance of the previously predicted PK 37 structures for their '
          'function. Deletion experiments showed that although PKs are not '
          'essential 38'},
 {'cite_spans': [],
  'ref_spans': [],
  'section': 'Abstract',
  'text': 'for replication, they provide genomes with a competitive advantage. '
          'However, although 39 replicons and full-length genomes lacking all '
          'PKs were replication competent, no infectious 40 virus was rescued '
          'from genomes containing less than one PK copy. This is consistent '
          'with our 41 earlier report describing the presence of putative '
          'packaging signals in the PK region. 42 43 author/funder. All rights '
          'reserved. No reuse allowed without permission.'}]
"""

tmp["abstract"][1]['text']
"""
'for replication, they provide genomes with a competitive advantage. However, although 39 replicons and full-length genomes lacking all PKs were replication competent, no infectious 40 virus was rescued from genomes containing less than one PK copy. This is consistent with our 41 earlier report describing the presence of putative packaging signals in the PK region. 42 43 author/funder. All rights reserved. No reuse allowed without permission.'
"""

tmp["body_text"]
tmp["body_text"][0]['text']
tmp["bib_entries"]
"""
>>> pprint(tmp["bib_entries"]["BIBREF9"])
{'authors': [{'first': 'N',
              'last': 'Stonehouse',
              'middle': ['J'],
              'suffix': ''}],
 'issn': '',
 'other_ids': {},
 'pages': '6864--6883',
 'ref_id': 'b9',
 'title': 'Both cis and trans Activities of Foot-and-Mouth Disease Virus 617 '
          '3D Polymerase Are Essential for Viral RNA Replication',
 'venue': 'J Virol',
 'volume': '90',
 'year': 2016}
"""

tmp["ref_entries"]
"""
>>> pprint(tmp["ref_entries"]["TABREF2"])
{'latex': None,
 'text': 'Wt, C11, ∆PK 34 and ∆PK 234 constructs all resulted in the '
         'production of infectious virus as was expected from the replicon '
         'experiments, with no alteration to input sequence. However, the C11 '
         '∆PK 1234, which replicated (albeit to a lesser degree) as a '
         'replicon, produced no recoverable infectious virus(Table 1). '
         'Interestingly, there were differences noted in both the',
 'type': 'table'}
"""

tmp["back_matter"]
"""
>>> pprint(tmp["back_matter"])
[{'cite_spans': [],
  'ref_spans': [],
  'section': 'annex',
  'text': 'author/funder. All rights reserved. No reuse allowed without '
          'permission.The copyright holder for this preprint (which was not '
          'peer-reviewed) is the The copyright holder for this preprint (which '
          'was not peer-reviewed) is the . '
          'https://doi.org/10.1101/2020.01.10.901801 doi: bioRxiv preprint'}]
"""
```

```python
class FileReader:
    def __init__(self, file_path):
        with open(file_path) as file:
            content = json.load(file)
            self.paper_id = content['paper_id']
            self.abstract = []
            self.body_text = []
            # Abstract
            for entry in content['abstract']:
                self.abstract.append(entry['text'])
            # Body text
            for entry in content['body_text']:
                self.body_text.append(entry['text'])
            self.abstract = '\n'.join(self.abstract)
            self.body_text = '\n'.join(self.body_text)
    def __repr__(self):
        return f'{self.paper_id}: {self.abstract[:200]}... {self.body_text[:200]}...'
first_row = FileReader(all_json[0])
print(first_row)
```
