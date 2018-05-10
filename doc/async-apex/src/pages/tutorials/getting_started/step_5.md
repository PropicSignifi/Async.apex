---
title: "Error Recovery"
description: "Error Recovery"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 5
---

## {$page.title}

Just like promises, we can recover from errors by returning a new Async(promise).

```javascript
promise.error(new ReturnAsyncFunc()) // recover from errors
    .then(new CustomCodeFunc()) // continue logic
    .fork();
```
