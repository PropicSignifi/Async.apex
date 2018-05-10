---
title: "Then/Catch/Finally"
description: "Then/Catch/Finally"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 4
---

## {$page.title}

We have corresponding terms for **then/catch/finally** in Async.apex: **then/error/done**. Their usages are the same.

```javascript
promise.then(R.debug)
    .error(new ReportFunc())
    .done(new CleanupFunc())
    .fork();
```

**Important** is that differently from promises, Async instances are lazy, which means that we need to **fork** them to trigger the execution.
