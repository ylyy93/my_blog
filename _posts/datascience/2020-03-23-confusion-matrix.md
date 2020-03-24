---
layout: post
title: Confusion Matrix
date: 2020-03-23 21:46 -0700
categories: Statistics
tags: [Machine Learning]
---

# [Terminology and derivations from a confusion matrix](https://en.wikipedia.org/wiki/Confusion_matrix)

* **condition positive (P)**: number of positive cases in the data
* **condition negative (N)**: number of negative cases in the data
* **true positive (TP)**
* **true negative (TN)**
* **false positive (FP)**: Type I  Error
* **false negative (FN)**: Type II Error
* **sensitivity, recall, hit rate, true positive rate (TPR)** (+, data)

$$
TPR = \frac{TP}{P} = \frac{TP}{TP+FN} = 1 - FNR
$$

* **specificity, selectivity, true negative rate (TNR)** (+, data)

$$
TNR = \frac{TN}{N} = \frac{TN}{TN+FP} = 1 - FPR
$$

* **precision, positive predictive value (PPV)** (+, pred)

$$
PPV = \frac{TP}{TP+FP}
$$

* **negative predictive rate (NPV)** (+, pred)

$$
NPV = \frac{TN}{TN+FN}
$$

* **miss rate, false negative rate (FNR)** (-,data)

$$
FNR = \frac{FN}{P} = \frac{FN}{FN+TP} = 1 - TPR
$$

* **fall-out, false positive rate (FPR)** (-,data)

$$
FPR = \frac{FP}{N} = \frac{FP}{FP+TN} = 1 - TNR
$$

* **false discovery rate (FDR)** (-,pred)

$$
FDR = \frac{FP}{FP + TP} = 1 - PPV
$$

* **false ommision rate (FOR)** (-,pred)

$$
FOR = \frac{FN}{FN+TN} = 1 - NPV
$$

* **Accuracy (ACC)**

$$
ACC = \frac{TP+TN}{P+N} = \frac{TP+TN}{TP+TN+FP+FN}
$$

* **F1 Score**: harmonic mean of precision and sensitivity

$$
F_1 = 2\cdot\frac{PPV\cdot TPR}{PPV + TPR} = \frac{2TP}{2TP+FP+FN}
$$
