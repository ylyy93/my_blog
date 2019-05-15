---
layout: post
title: Sbatch options with slurm workload manager
date: 2019-05-15 10:49 -0600
categories: Tech
tags: [HPC]
---

先看一个实例。
```
#!/bin/bash

#SBATCH -p shas                # Send this job to the serial partition
#SBATCH -N 17                   # number of nodes
#SBTACH -J jobname             # job name
#SBATCH --mem=96000            # memory per node
#SBATCH --ntasks-per-node=6
#SBATCH -t 0-3:00                  # wall time (D-HH:MM)
#SBATCH -o jobname.%j.out           # STDOUT (%j = JobId)
#SBATCH -e jobname.%j.err           # STDERR (%j = JobId)
#SBATCH --mail-type=END,FAIL       # notifications for job done & fail
#SBATCH --mail-user=your@email.com # send-to address
```

- sbatch submits a batch script to Slurm.
- sbatch exits immediately after the script is successfully transferred to the Slurm controller and assigned a Slurm job ID.
- in `"slurm-%j.out"`, the `"%j"` is replaced with the job allocation number.


- `--mem=`: Specify the real memory required per node.
- `-N` or `--nodes=`: Number of nodes
- `-n` or `--ntasks=`: default is one task per node
- `--ntasks-per-core=`: Request the maximum ntasks be invoked on each core.
- `--ntasks-per-node=`: Request that ntasks be invoked on each node.


###### Some useful commands in Linux

Number of CPUs/Cores
```
cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l
```
or
```
grep -c ^processor /proc/cpuinfo     
```
or
```
nproc --all
```
or (this also applies to MacOS)
```
getconf _NPROCESSORS_ONLN
```
