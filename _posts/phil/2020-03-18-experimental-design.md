---
layout: post
title: Experimental Design
date: 2020-03-18 17:53 -0700
categories: Statistics
tags: [sas]
---

# L1: Introduction to Six Principles of Experimental Design

### Summary
1. Principle of Comparative Experimentation
2. “Fundamental Principle” of Statistical Inference
3. Principle of Experimental Manipulation
4. Principle of Blocking
5. Principle of Factorial Experimentation
6. Principle of Randomization

### Principle of Comparative Experimentation
> Differences between responses to treatments will be less affected by uncontrolled influences than individual responses to treatments.

You need a control treatment in your experiment!

### “Fundamental Principle” of Statistical Inference
> You make inference to the population from which you sample.

### Principle of Experimental Manipulation
> In designed experiments (“scientific studies”) you can make inference about causal relationships. In observational studies you cannot.

##### Designed Experiments:
Studies in which the experimenter **manipulates** the experimental conditions or “treatments” experienced by the experimental units using a randomization scheme. (Sometimes called “Scientific Studies” or “Experimental Studies”).

##### Observational Studies:
Studies in which the experimenter **observes or measures**, but doesn’t manipulate the conditions experienced by the experimental units and does not have control over which experimental units receive which treatment or condition.

### Principle of Blocking
**Def**: An **experimental unit (EU)** is the object (e.g. subject, plant, pot, test tube) that is randomly assigned to a treatment.

**Def**: A **block** is a grouping of experimental units (EUs) into (relatively) homogeneous groups.

**Idea of Blocking**: Assign experimental units (EU’s) to blocks so that EU’s in the same block are **as alike as possible**. Some blocks will have higher than average values; some blocks will have lower than average values. Comparison of treatment means will be more accurate, because each treatment has an equal number (=1) of observations in each block.

### Principle of Factorial Experimentation
> Efficiency can be gained by using factorial treatment structures because:
1. If there is an interaction, you can test it and study it.
2. If there is no interaction, you can more accurately estimate the main effect of each factor by averaging over the levels of the other factor. (Each estimate uses all the data!)

### Principle of Randomization
> Whenever possible the assignment of treatments to experimental units should be done at random: (1) Randomization avoids bias (easy), and (2) the randomization justifies the statistical hypothesis test (hard).

Randomization made the estimate of treatment effect unbiased.

(R. A. Fisher, 1935): Randomization does not make error terms independent, but randomization allows us to do a valid “randomization test”. The normal analysis that assumes, independent errors is generally a good approximation to the randomization test.

# L2: The Oneway Model

### Motivating Example: The Geranium Data

Fifteen pots (one plant per pot) randomly assigned three trts (A, B, C), without restriction “Completely Randomized Design” (CRD). Five pots per trt.

$$Y_{ij} = \mu + \tau_i + \varepsilon_{ij}.$$

##### Method 1:  Omit the intercept ($\mu$) and use the "means" parameterization of the same model, relabeling the $\tau$'s as $\mu$'s:
The parameters are treatment means.

$$
\left(\begin{array}{ccc}
1 & 0 & 0\\
1 & 0 & 0\\
0 & 1 & 0\\
0 & 1 & 0\\
0 & 0 & 1\\
0 & 0 & 1
\end{array}\right)
\left(\begin{array}{c}
\mu_1 \\
\mu_2 \\
\mu_3
\end{array}\right)
$$

##### Method 2: Omit the first of the "effects" columns (the R lm function default):
* $\mu$ is the mean for trt 1
* the $\tau$'s are the deviations of the other trt means from the trt 1 mean.

$$
\left(\begin{array}{ccc}
1 & 0 & 0\\
1 & 0 & 0\\
1 & 1 & 0\\
1 & 1 & 0\\
1 & 0 & 1\\
1 & 0 & 1
\end{array}\right)
\left(\begin{array}{c}
\mu \\
\tau_2 \\
\tau_3
\end{array}\right)
$$

##### Method 3: Omit the last of the “effects” (not the default, but R can do this.)
* $\mu$ is the mean for trt 3
* the $\tau$'s are the deviations of the other trt means from the trt 3 mean.

$$
\left(\begin{array}{ccc}
1 & 1 & 0\\
1 & 1 & 0\\
1 & 0 & 1\\
1 & 0 & 1\\
1 & 0 & 0\\
1 & 0 & 0
\end{array}\right)
\left(\begin{array}{c}
\mu \\
\tau_1 \\
\tau_2
\end{array}\right)
$$

##### Method 4: Constrain $\sum \tau_i = 0$ and replace $\tau_3$ with $-\tau_1-\tau_2$ (MINITAB, SPSS, and some SAS procedures, model fit in JMP do this; R can also be made to do this)

$$
\left(\begin{array}{ccc}
1 & 1 & 0\\
1 & 1 & 0\\
1 & 0 & 1\\
1 & 0 & 1\\
1 & -1 & -1\\
1 & -1 & -1
\end{array}\right)
\left(\begin{array}{c}
\mu \\
\tau_1 \\
\tau_2
\end{array}\right)
$$

* $\mu$ is the average of the three true trt means,
* the $\tau$'s are the deviations of the individual trt means from the average of the trt means.
(This is called the "sum-to-zero" parameterization)

##### Method 5: “Orthogonal Polynomials”: (R default for ordinal predictors)

$$
\left(\begin{array}{ccc}
1 & -1 & 1\\
1 & -1 & 1\\
1 & 0 & -2\\
1 & 0 & -2\\
1 & 1 & 1\\
1 & 1 & 1
\end{array}\right)
\left(\begin{array}{c}
\mu \\
\tau_1 \\
\tau_2
\end{array}\right)
$$

##### Method 6: The "Helmert" parameterization: compares each treatment level to the average of the treatment levels that follow it.

$$
\left(\begin{array}{ccc}
1 & 2 & 0\\
1 & 2 & 0\\
1 & -1 & 1\\
1 & -1 & 1\\
1 & -1 & -1\\
1 & -1 & -1
\end{array}\right)
\left(\begin{array}{c}
\mu \\
\tau_1 \\
\tau_2
\end{array}\right)
$$

* $\mu$ = Average of the three trts
* $\tau$ = Comparison of trt1 to average of 2 and 3 (multiplied by 2)
* $\tau$ = Comparison of trt2 average to trt3 average

### What does the `lm` function in R do?

By default:

- (1) For unordered “factor” variables (called "class" variables in SAS) lm uses the "treatment" parameterization (Method 2), which leaves out the column associated with the first (alphabetically) of the factor levels.
- (2) For ordered factor variables lm uses the "poly" set of orthogonal polynomial contrasts (Method 5, but each column multiplied by a constant).


```r
options(contrasts=c("","")) # set the choices for unordered and ordered factors, respectively.
```

* Standard Choices: `contr.treatment`, `contr.SAS`, `contr.sum`, `constr.poly`, and `contr.helmert`
* use `-1` syntax to omit intercept, then no treatment levels are omitted by the `contr.treatment`, `contr.SAS`.

```
> data1
   trt drywt
1    1  1.02
2    1  0.79
3    1  1.00
4    1  0.59
5    1  0.97
6    2  1.00
7    2  1.21
8    2  1.22
9    2  0.96
10   2  0.79
11   3  0.99
12   3  1.36
13   3  1.17
14   3  1.22
15   3  1.12

> trt <- factor(trt)
> g <- lm(drywt~trt)
> summary(g)

Call:
lm(formula = drywt ~ trt)

Residuals:
   Min     1Q Median     3Q    Max
-0.284 -0.080 -0.002  0.136  0.188

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   0.8740     0.0752  11.622  6.9e-08 ***
trt2          0.1620     0.1064   1.523    0.154    
trt3          0.2980     0.1064   2.802    0.016 *  
---
Signif. codes:  
0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1682 on 12 degrees of freedom
Multiple R-squared:  0.3961,	Adjusted R-squared:  0.2955
F-statistic: 3.936 on 2 and 12 DF,  p-value: 0.0485

> model.matrix(g)
   (Intercept) trt2 trt3
1            1    0    0
2            1    0    0
3            1    0    0
4            1    0    0
5            1    0    0
6            1    1    0
7            1    1    0
8            1    1    0
9            1    1    0
10           1    1    0
11           1    0    1
12           1    0    1
13           1    0    1
14           1    0    1
15           1    0    1

> contrasts(trt)
  2 3
1 0 0
2 1 0
3 0 1

> g <- lm(drywt~trt -1)
> model.matrix(g)
   trt1 trt2 trt3
1     1    0    0
2     1    0    0
3     1    0    0
4     1    0    0
5     1    0    0
6     0    1    0
7     0    1    0
8     0    1    0
9     0    1    0
10    0    1    0
11    0    0    1
12    0    0    1
13    0    0    1
14    0    0    1
15    0    0    1
```

##### `contr.treatment` (default)
```
> options(contrasts = c("contr.treatment", "contr.poly"))
> g <- lm(drywt~trt)
> model.matrix(g)
   (Intercept) trt2 trt3
1            1    0    0
2            1    0    0
3            1    0    0
4            1    0    0
5            1    0    0
6            1    1    0
7            1    1    0
8            1    1    0
9            1    1    0
10           1    1    0
11           1    0    1
12           1    0    1
13           1    0    1
14           1    0    1
15           1    0    1
```

##### `contr.SAS`
```
> options(contrasts = c("contr.SAS", "contr.poly"))
> g <- lm(drywt~trt)
> model.matrix(g)
   (Intercept) trt1 trt2
1            1    1    0
2            1    1    0
3            1    1    0
4            1    1    0
5            1    1    0
6            1    0    1
7            1    0    1
8            1    0    1
9            1    0    1
10           1    0    1
11           1    0    0
12           1    0    0
13           1    0    0
14           1    0    0
15           1    0    0
```


##### `contr.helmert`
```
> options(contrasts = c("contr.helmert", "contr.poly"))
> g <- lm(drywt~trt)
> model.matrix(g)
   (Intercept) trt1 trt2
1            1   -1   -1
2            1   -1   -1
3            1   -1   -1
4            1   -1   -1
5            1   -1   -1
6            1    1   -1
7            1    1   -1
8            1    1   -1
9            1    1   -1
10           1    1   -1
11           1    0    2
12           1    0    2
13           1    0    2
14           1    0    2
15           1    0    2
```

##### `contr.sum`
```
> options(contrasts = c("contr.sum", "contr.poly"))
> g <- lm(drywt~trt)
> model.matrix(g)
   (Intercept) trt1 trt2
1            1    1    0
2            1    1    0
3            1    1    0
4            1    1    0
5            1    1    0
6            1    0    1
7            1    0    1
8            1    0    1
9            1    0    1
10           1    0    1
11           1   -1   -1
12           1   -1   -1
13           1   -1   -1
14           1   -1   -1
15           1   -1   -1
```

##### Summary
```
> contr.treatment(3)
  2 3
1 0 0
2 1 0
3 0 1
> contr.SAS(3)
  1 2
1 1 0
2 0 1
3 0 0
> contr.sum(3)
  [,1] [,2]
1    1    0
2    0    1
3   -1   -1
> contr.poly(3)
                .L         .Q
[1,] -7.071068e-01  0.4082483
[2,] -7.850462e-17 -0.8164966
[3,]  7.071068e-01  0.4082483
```
