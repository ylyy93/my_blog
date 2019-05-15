---
layout: post
title: Memory Management in R
date: 2019-05-08 14:00 -0600
categories: Tech
tags: [R]
---

- `object_size()`:

### R package `pryr`
- `mem_used()`, `mem_change()`: how R allocate and free memory
### R package `lineprof`
- how memory is allocated and released in larger code blocks.
- `address()` or `refs()`: how R modifies in place or modifies a copy.

check memory of node `shas0208` in Megabytes
```
sinfo -Nel -n shas0208
```

Method 1:
```
showMemoryUse <- function(sort="size", decreasing=FALSE, limit) {

  objectList <- ls(parent.frame())

  oneKB <- 1024
  oneMB <- 1048576
  oneGB <- 1073741824

  memoryUse <- sapply(objectList, function(x) as.numeric(object.size(eval(parse(text=x)))))

  memListing <- sapply(memoryUse, function(size) {
        if (size >= oneGB) return(paste(round(size/oneGB,2), "GB"))
        else if (size >= oneMB) return(paste(round(size/oneMB,2), "MB"))
        else if (size >= oneKB) return(paste(round(size/oneKB,2), "kB"))
        else return(paste(size, "bytes"))
      })

  memListing <- data.frame(objectName=names(memListing),memorySize=memListing,row.names=NULL)

  if (sort=="alphabetical") memListing <- memListing[order(memListing$objectName,decreasing=decreasing),]
  else memListing <- memListing[order(memoryUse,decreasing=decreasing),] #will run if sort not specified or "size"

  if(!missing(limit)) memListing <- memListing[1:limit,]

  print(memListing, row.names=FALSE)
  return(invisible(memListing))
}
showMemoryUse(decreasing=TRUE, limit=5)
```

Method 2:
```
# improved list of objects
.ls.objects <- function (pos = 1, pattern, order.by,
                        decreasing=FALSE, head=FALSE, n=5) {
    napply <- function(names, fn) sapply(names, function(x)
                                         fn(get(x, pos = pos)))
    names <- ls(pos = pos, pattern = pattern)
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.prettysize <- napply(names, function(x) {
                           format(utils::object.size(x), units = "auto") })
    obj.size <- napply(names, object.size)
    obj.dim <- t(napply(names, function(x)
                        as.numeric(dim(x))[1:2]))
    vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
    names(out) <- c("Type", "Size", "PrettySize", "Length/Rows", "Columns")
    if (!missing(order.by))
        out <- out[order(out[[order.by]], decreasing=decreasing), ]
    if (head)
        out <- head(out, n)
    out
}

# shorthand
lsos <- function(..., n=10) {
    .ls.objects(..., order.by="Size", decreasing=TRUE, head=TRUE, n=n)
}

lsos()
```
- [Tricks to manage the available memory in an R session](https://stackoverflow.com/questions/1358003/tricks-to-manage-the-available-memory-in-an-r-session)
