---
layout: post
title: robust and automatic large-scale time series forecasting
date: 2019-04-05 12:49 -0600
categories: Tech
tags: [analytics]
---

Goal: developing **robust** and **automatic** **large-scale** time series forecasting.

问题的几个方面：
1. 数据清理：缺失数据，异常值， level changes and transformation.
  * Level changes are different in that they represent a more permanent change in the level of the time series, in contrast to anomalies, where the time series returns to its previous level at trend after a brief period. They may result from launches, logging changes, or external events. At a minimum, adjusting for level changes results in a longer effective time series, and often makes trend estimation easier when the models are finally fit.
2. Adjustment for effects: 假期，季节性，day-of-week effects
3. 数据分解： 分成几个子时间序列 (by地区，by设备类型，by操作系统，或者几个的combinations)
4. 结果整合。用几个不同的模型并对模型结果进行整合。
5. 预测不确定性分析。

具体问题分析：
1. daily data
2. 通过一到两年的daily data来推断接下来一到两年的水平。
3. 要预测的变量：
  * overall search query volume
  * volume of particular types of queries
  * revenue
  * views and minutes of video watched on Google-owned YouTube
  * usage of sundry internal resources

本文中的forecasting指的是：
- 用的是time series model而非explanatory model。
- 为什么这么选择：
    * 我们对系统的了解并不深刻。
    * 我们需要知道或者事先预测predictors的值。通常比较困难。
    * 我们的核心目标是知道是啥，而并没有很关心为啥。
    * ts model可能比explanatory model或者mixed model结果更加精确。
- 跟CausalImpact不同。


**[Side Note: Anomaly Detection]**
- Twitter's AnomalyDetection
- Netflix' RAD (Robust Anomaly Detection)
