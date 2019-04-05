---
layout: post
title: Bayesian structural time series
date: 2019-04-04 14:18 -0600
categories: Tech
tags: [analytics]
---

- **1. [Facebook `Prophet` system for time series forecasting]**
- **2. [Google `bsts` `R` package]**

Goal: forecasting daily data into the distance future.
Method:
 * Facebook: regularized regression
 * averaging ensemble of forecast
 * both work with daily data with careful treatment of holidays.
 
## Bayesian structural time series model (State space model/Kalman Filter Model/Dynamic Linear models)
