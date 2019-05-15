---
layout: post
title: Playground on Summit HPC
date: 2019-05-15 13:28 -0600
categories: Tech
tags: [HPC]
---

In this post, I will show you how to create an interactive playground on Summit HPC. Using this technique, you can test your script before submitting your batch job file.

First, create an interative session.
```
sinteractive --partition=shas --qos=normal --time=01:00:00 --ntasks=6 --nodes=1 --mem=0
```
这里， `ntasks`
决定了每个node上可以并行的task个数。只有当其大于一，`Rmpi`才能work。

You will need two files:

`control.R`
```
# Install dependencies
list.of.packages <- c("Rmpi", "doSNOW","foreach","doRNG",
                      "iterators","parallel","Rcpp")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
invisible(lapply(list.of.packages, require, character.only = TRUE))

# You can pass arguments here
args <- commandArgs(TRUE)
n <- as.double(args[1])
delta <- as.double(args[2])
working.directory = '/path/to/code'
worker.script = 'fitting.R'

cl = getMPIcluster()
clusterExport(cl, ls())
setwd(working.directory)
source(worker.script)

clusterEvalQ(cl, setwd(working.directory))
clusterEvalQ(cl, source(worker.script))
registerDoSNOW(cl)
rdata_name = paste0(working.directory,"/../results/result_n",n,"delta_",delta,".rda")

iter0 = 1:100
nreps = length(iter0)
seedM = rbind(rep(401,nreps),c(iter0),c(iter0))
result = foreach(iter = iter0, .combine=rbind,.maxcombine=nreps,.options.RNG=seedM,
              .multicombine=TRUE, .errorhandling = 'remove') %dorng% {

                res =  run.sim()
                save(res,file=paste0(working.directory,"/../results/n_",n,"delta_",delta,"iter_",iter,".rda"))
                return(res)             
                }
.Last = NULL
save.image(rdata_name)
stopCluster(cl)
```

`fitting.R`: put your main running code here. Pay attention, you should also include all necessary libraries here.
```
library(spatstat)
run.sim <-function(){
  runif(3)
}
```

Then, in your terminal, run
```
R_PROFILE=/home/liujl@colostate.edu/R/x86_64-pc-linux-gnu-library/3.5/snow/RMPISNOWprofile;
export R_PROFILE
module load R
ml gcc
ml openmpi/2.0.1

mpirun Rscript --no-save control.R 10000 6
```

Here, $n=10000$ and $\delta=6$.

When you are done, in terminal, run
```
exit
```
