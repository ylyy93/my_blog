---
layout: post
title: Imagemagick
date: 2019-11-21 20:57 -0800
categories: Coding
tags: [Linux]
---

### 基本命令

- magick: 创建、编辑图像，转换图像格式，以及调整图像大小、模糊、裁切、除去杂点、抖动 ( dither )、绘图、翻转、合并、重新采样等。
- convert: 等同于 magick 命令。
- identify: 输出一个或多个图像文件的格式和特征信息，如分辨率、大小、尺寸、色彩空间等。
- mogrify: 与 magick 功能一样，不过不需要指定输出文件，自动覆盖原始图像文件。
- composite: 将一个图片或多个图片组合成新图片。
- montage: 组合多个独立的图像来创建合成图像。每个图像都可以用边框，透明度等特性进行装饰。
- compare: 从数学和视觉角度比较源图像与重建图像之间的差异。
- display: 在任何 X server 上显示一个图像或图像序列。
- animate: 在任何 X server 上显示图像序列。
- import: 保存 X server 上的任何可见窗口并把它作为图像文件输出。可以捕捉单个窗口，整个屏幕或屏幕的任意矩形部分。
- conjure: 解释并执行 MSL ( Magick Scripting Language ) 写的脚本。
- stream: 一个轻量级工具，用于将图像或部分图像的一个或多个像素组件流式传输到存储设备。在处理大图像或原始像素组件时很有用。

### 命令格式

```bash
command [options] input_image output_image
```

比如我们将一张宽高 300x300 的图片 goods.png 转换成 200x200 的goods.jpg，可以这样用

```bash
convert -resize 200x200 goods.png goods.jpg
```

Or

```bash
convert goods.png -resize 200x200 goods.jpg
```

#### 指定文件格式
```bash
convert goods.png png8:goods_8.png
```

### Examples

将一张宽高为 900x600 的图片 goods.jpg 生成宽高为 150x100 的缩略图 thumbnail.jpg

```bash
convert -resize 150x100 -quality 70 -strip goods.jpg thumbnail.jpg
```

- -resize 150x100：定义输出的缩略图尺寸为 150x100。
- -quality 70：降低缩略图的质量为 70，取值范围 1 ( 最低图像质量和最高压缩率 ) 到 100 ( 最高图像质量和最低压缩率 )，默认值根据输出格式有 75、92、100，选项适用于 JPEG / MIFF / PNG。
- -strip：让缩略图移除图片内嵌的所有配置文件，注释等信息，以减小文件大小。


### 定义输出文件名

default: `frame-%d.jpg`
```bash
convert  rain.gif  frame_%d.jpg
```


### PDF 与图片互转

PDF 与图片互转跟 GIF 很相似，稍微有些格式自身需要注意的区别。
IM 本身是不具备解析 PDF 的功能的，需要依赖专门解析这种格式的外部程序，如官方指明的 **ghostscript** 解析程序。
首先安装 gs，还是演示 Mac OS 安装：brew install ghostscript。


```bash
convert  -density 150  -flatten  'download.pdf[0]'  first_page.jpg
```

```bash
convert  -density 150  -background white  -alpha remove  download.pdf  download.jpg
```


- 当转换 PDF 成 JPG 格式图像时，某些情况得到的 JPG 图片会出现黑色背景（转换成 PNG 不会），所以可以使用 -flatten 选项让其保持白色背景，但加上这个选项，多页 PDF 不会分成多个 JPG 图像，
- 第二种方式 -background white -alpha remove 则可以一次命令转换多页 PDF 成多个图像并保持白色背景。
- 第二种方式 IM 内部应该是一页一页的转换，所以一个 10 页的 PDF 耗时会比较久，采用第一种方式让 Node.js 多进程同时转换该 PDF 可以提升速率。
- -density：指定输出图像的分辨率 ( DPI )，在 Mac OS 上，默认的分辨率 ( 72 ) 输出的图像字迹不清，需要更高分辨率获得清晰的图像。


|size 的形式|大概的说明(实际效果对于不同的选项可能差别较大)|
|---|---|
|scale%|宽和高同时根据指定的百分比缩放|
|scale‑x%scale‑y%|宽和高根据指定的百分比分别缩放|
|width|指定宽度, 高度根据原尺寸比例自动确定|
|width x height|指定最大的宽度和高度, 图像宽高原比例保存不变(注意没空格, 下同)|
|width x height^|指定最小的宽度和高度, 宽高原比例不变|
|width x height!|指定宽度和高度, 忽略原始比例|
|width x height>|和 width x height 一样, 但只对比这个尺寸大的图像有作用|
|width x height<|和 width x height 一样, 但只对比这个尺寸小的图像有作用|
|area@|等比例缩放图像, 使其总像素值不大于 area.|


```bash
convert logo: -resize '200%' bigWiz.png
convert logo: -resize '200x50%' longShortWiz.png
convert logo: -resize '100x200' notThinWiz.png
convert logo: -resize '100x200^' biggerNotThinWiz.png
convert logo: -resize '100x200!' dochThinWiz.png
```

### 只指定宽或者高
```bash
convert logo: -resize '100' wiz1.png
convert logo: -resize 'x200' wiz2.png
convert logo: -resize '100x200>' wiz3.png
convert logo: -resize '100x200<' wiz4.png
```

### 图像定位中的偏移

指定这个矩形区域的宽和高, 还需要指定它的一个起始点(左上角的点). 下面的第一个例子中, 我们指定了一个 100×200 的区域, 位置在 x=10, y=20, 或者我们应该写成 (x,y) = (10,20).

```bash
convert logo: -region '100x200+10+20' -negate wizNeg1.png
convert logo: -region '100x200-10+20' -negate wizNeg2.png
convert logo: -gravity center -region '100x200-10+20' -negate wizNeg3.png
```







## References

- [ImageMagick命令行使用方法](https://www.zouyesheng.com/imagemagick.html)
