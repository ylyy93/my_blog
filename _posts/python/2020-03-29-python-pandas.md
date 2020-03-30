---
layout: post
title: Python - Pandas
date: 2020-03-29 19:04 -0700
categories: Coding
tags: [Python]
---

```python
import numpy as np
import pandas as pd
dates = pd.date_range('20130101', periods=6)
df = pd.DataFrame(np.random.randn(6, 4), index=dates, columns=list('ABCD'))
df
```

```bash
            A         B         C         D
2013-01-01  0.469112 -0.282863 -1.509059 -1.135632
2013-01-02  1.212112 -0.173215  0.119209 -1.044236
2013-01-03 -0.861849 -2.104569 -0.494929  1.071804
2013-01-04  0.721555 -0.706771 -1.039575  0.271860
2013-01-05 -0.424972  0.567020  0.276232 -1.087401
2013-01-06 -0.673690  0.113648 -1.478427  0.524988
```


```python
df2 = pd.DataFrame({'A': 1.,
                    'B': pd.Timestamp('20130102'),
                    'C': pd.Series(1, index=list(range(4)), dtype='float32'),
                    'D': np.array([3] * 4, dtype='int32'),
                    'E': pd.Categorical(["test", "train", "test", "train"]),
                    'F': 'foo'})

df2                    
```

```bash
     A          B    C  D      E    F
0  1.0 2013-01-02  1.0  3   test  foo
1  1.0 2013-01-02  1.0  3  train  foo
2  1.0 2013-01-02  1.0  3   test  foo
3  1.0 2013-01-02  1.0  3  train  foo
```

```python
df2.dtypes

# A           float64
# B    datetime64[ns]
# C           float32
# D             int32
# E          category
# F            object
# dtype: object
```

```python
df.head()
df.tail(3)
df.index # row names
df.columns # col names
df.to_numpy()
df.describe() # summary
df.T # transpose
df.sort_index(axis=1, ascending=False) # sort by column name
df.sort_values(by='B') # sort by values
# select columns
df.A
df['A']
df.loc[:, ['A', 'B']]
# select rows
df[0:3]
df['20130102':'20130104']
```


## Select by label
```python
df.loc[dates[0]]
# both columns and rows
df.loc['20130102':'20130104', ['A', 'B']]
# scalar value
df.loc[dates[0], 'A']
# faster scalar value
df.at[dates[0], 'A']
```

## Select by position
```python
# rows
df.iloc[3]
df.iloc[1:3, :]
# columns
df.iloc[:, 1:3]
# rows and columns
df.iloc[3:5, 0:2]
df.iloc[[1, 2, 4], [0, 2]]
# scalar value
df.iloc[1, 1]
# faster scalar
df.iat[1, 1]
```

## Boolean indexing

```python
df[df['A'] > 0]
df[df > 0]
df2 = df.copy()
df2['E'] = ['one', 'one', 'two', 'three', 'four', 'three']
df2
df2[df2['E'].isin(['two', 'four'])]
```

## Missing value
```python
df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])
df1.loc[dates[0]:dates[1], 'E'] = 1
df1
```

```python
df1.dropna(how='any')
df1.fillna(value=5)
pd.isna(df1)
```

## Operations

```python
df.mean() # by columns
df.mean(1) # by row
```

... To be continued 


- [](https://pandas.pydata.org/pandas-docs/stable/getting_started/10min.html)
