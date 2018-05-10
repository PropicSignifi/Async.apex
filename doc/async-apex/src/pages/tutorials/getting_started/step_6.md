---
title: "Chaining"
description: "Chaining"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 6
---

## {$page.title}

Funcs in then/error/done are executed synchronously. Only Async.Executor instances are executed asynchronously. That means that if we want to make a piece of code asynchronous, we will have to wrap it in Async.

```javascript
promise.then(new SyncCodeFunc()) // sync code
    .then(new ReturnAsyncFunc()) // async code executed in the returning Async
    .fork();
```
