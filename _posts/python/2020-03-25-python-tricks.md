---
layout: post
title: Python - tricks (MAC OSX)
date: 2020-03-25 10:45 -0700
categories: Coding
tags: [Python]
---

# Downgrade packages
```bash
pip show numpy
pip install -U numpy==1.12.0
```

# Set python alias (default 3.x)
In `~/.bashrc`
```bash
alias python=/usr/local/bin/python3
```

# Check where pip is installing the modules
```bash
which -a pip
```

# Solving `urllib and “SSL: CERTIFICATE_VERIFY_FAILED” Error`

```bash
pip install certifi
/Applications/Python\ 3.8/Install\ Certificates.command
```

# Virtual Environments and Packages

## Option 1: Anaconda Virtual Environments
```bash
# create an environment called cs231n
conda create -n cs231n python=3.7 anaconda
conda install -n cs231n scipy=0.15.0
conda create -n myenv python=3.6 scipy=0.15.0 astroid babel
# activate
source activate cs231n
# exit
source deactivate cs231n
```

## Option 2: Python `virtualenv`
```bash
cd path
sudo pip install virtualenv
virtualenv -p python3 .env # Create
source .env/bin/activate
pip install -r requirements.txt
deactivate
```

- [Managing environments](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
