---
layout: post
title: Imbalance data
date: 2020-03-24 09:58 -0700
categories: Statistics
tags: [Machine Learning]
---

# Webclips

* Decision trees frequently perform well on imbalanced data. They work by learning a hierarchy of if/else questions and this can force both classes to be addressed.

* **Oversampling** techniques: always split into test and train sets BEFORE trying oversampling techniques. Oversampling before splitting the data can allow the same observations to be present in both the test and train sets. This can allow our model to simply memorize specific data points and cause overfitting and poor generalization to the test data.

* **Undersampling** techniques: when you have tons of data.

* **(Synthetic Minority Oversampling Technique) SMOTE**: uses a NN algorithm to generate new and synthetic data to train the model. (Splitting first!)
