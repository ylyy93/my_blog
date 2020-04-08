---
layout: post
title: Python - Deep Learning on Mac OS
date: 2020-04-07 23:43 -0700
categories: Coding
tags: [Python]
---



## 1. Install Xcode
```bash
sudo xcodebuild -license
sudo xcode-select — install
```

## 2. Brew
Add the following to `~/.bash_profile` or `~/.bashrc`:

```bash
export PATH=/usr/local/bin:$PATH
```

```bash
brew update
source ~/.bashrc
```

## 3. Python (version 3.7)
Make sure python3 version is at most 3.7 (Current version of Tensorflow does not support python3.8)

```
brew install python3
```

## 4. pip

```bash
brew install wget
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
sudo rm -rf ~/get-pip.py ~/.cache/pip
```

## 5. Create Virtual Environment

```bash
pip3 install virtualenv virtualenvwrapper
```

Add the following to `~/.bash_profile` or `~/.bashrc`:
```bash
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
```

```bash
source ~/.bash_profile
mkvirtualenv dl4cv -p /usr/local/bin/python3.7
workon dl4cv
```

## 6. Opencv

```bash
pip install numpy
brew install cmake pkg-config
brew install jpeg libpng libtiff openexr eigen tbb hdf5

cd
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
    -D PYTHON3_LIBRARY=`python -c 'import subprocess ; import sys ; s = subprocess.check_output("python-config --configdir", shell=True).decode("utf-8").strip() ; (M, m) = sys.version_info[:2] ; print("{}/libpython{}.{}.dylib".format(s, M, m))'` \
    -D PYTHON3_INCLUDE_DIR=`python -c 'import distutils.sysconfig as s; print(s.get_python_inc())'` \
    -D PYTHON3_EXECUTABLE=$VIRTUAL_ENV/bin/python \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_EXAMPLES=ON ..
```

```bash
make -j4
sudo make install
ln -s /usr/local/lib/python3.7/site-packages/cv2/python-3.7/cv2.cpython-37m-darwin.so cv2.so
```

## 7. Tensorflow

```bash
pip install scipy pillow
pip install imutils h5py requests progressbar2
pip install scikit-learn scikit-image
pip install matplotlib
mkdir .matplotlib
touch ~/.matplotlib/matplotlibrc
echo "backend: TkAgg" >> ~/.matplotlib/matplotlibrc
pip install tensorflow
pip install keras
pip install dlib
```

## Other Issues

### Remove virtualenv
```
deactivate ENVNAME
rmvirtualenv ENVNAME
```

## References

- [Deep Learning on MacOS Catalina](https://mc.ai/deep-learning-on-macos-catalina/)
- [macOS for deep learning with Python, TensorFlow, and Keras](https://www.pyimagesearch.com/2017/09/29/macos-for-deep-learning-with-python-tensorflow-and-keras/)
