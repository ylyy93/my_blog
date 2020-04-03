---
layout: post
title: Python - Dockerize
date: 2020-04-02 20:51 -0700
categories: Coding
tags: [Python]
---

## Step 1: Prepare two files and place under the folder `my_1st_docker_build`
### 1. `Dockerfile`
```
FROM python:3
ADD my_script.py /
RUN pip install pystrich
CMD [ "python", "./my_script.py"]
```

* `FROM` tells Docker which image you base your image on
* `RUN`  tells Docker which additional commands to execute
* `CMD`  tells Docker to execute the command when the image loads

### 2. Script
The python script `my_script.py`

```python
# Sample taken from pyStrich GitHub repository
# https://github.com/mmulqueen/pyStrich
from pystrich.datamatrix import DataMatrixEncoder

encoder = DataMatrixEncoder('This is a DataMatrix.')
encoder.save('./datamatrix_test.png')
print(encoder.get_ascii())
```

## Step 2: Building
```
docker build -t python-barcode .
```

## Step 3: Running
```
docker run python-barcode
```

## Single Line alternative
```
docker run -it --rm --name my-first-python-script -v "$PWD":/usr/src/widget_app python:3 python my_script.py
```

* Avoid putting any unused files in your build directory. Docker makes tarballs of everything in the current directory and sends that to the Docker daemon, so if you have unnecessary files, those are included.

## Step 4: Deleting Docker container
```
docker ps
docker ps -a # to see all containers, including those not running
docker rm 3a1c658c7988 # single container
docker ps -q -a | xargs docker rm # delete all your containers
```

## Step 5: Deleting Docker Images
```
docker images
docker rmi 4a33d1e8acbf
# > docker run python-barcode
# Unable to find image 'python-barcode:latest' locally
docker rmi $(docker images | grep "<none>" | awk '{print $3}') # delete all untagged images
docker rmi $(docker images | awk '{print $3}') # delete all images
```

### Reference
- [Dockerize your Python Application](https://runnable.com/docker/python/dockerize-your-python-application)
