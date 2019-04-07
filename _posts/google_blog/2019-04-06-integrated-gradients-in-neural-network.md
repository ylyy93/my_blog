---
layout: post
title: Integrated Gradients in Neural Network
date: 2019-04-06 17:01 -0600
categories: Tech
tags: [analytics]
---

Field: Neural network

我们可以通过深层神经网络来给图像assign label，但是我们想知道，图的哪一部分导致了这个label？
在线性模型中，我们可以通过coefficient的大小来判断。这个coefficient其实可以理解为gradient。
所以我们可以考虑输出相对于输入的gradient。但问题是深层神经网络高度非线性，一种办法是用局部线性逼近。


Problem: object recognition

Goal: Which pixel led to a positive prediction?
- or Can we identify what parts of the input the deep network finds noteworthy?

How:
- input: R,G,B values
- output: probability(score) for each of 1000 different ImageNet categories
- method: multinomial logit (Softmax) function.

### Feature Imporatance
#### Gradients

- For linear model, examine the coefficients of the features

###### Why do we care about feature importance?
- check which coefficients don't match our intuition.
- check for overfitting
- check for biases in the training Data
- check if some features are correlated
- improve the network

##### Local linear approximation

- a Taylor approximation of the prediction function at the input.
- 对每个pixel我们进行求导。所以我们得到的gradient是一个3dim的矩阵。
- 这个矩阵有三个维度，两个维度对应图像的高和宽，一个维度对应（R,G,B)值。

问题是，原始数据的gradient都很小。为了解决这个问题， 采用了scale down的方式来降低brightness。在不同的scale下gradient的值不同。这个scale parameter为$\alpha$.

 "integrated gradients" 其实就是把在不同scale下的gradient进行加和。


#### Math
有时间细看。
