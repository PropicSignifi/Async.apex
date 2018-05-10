---
title: "Executor"
description: "Async Executor"
layout: "guide"
icon: "cloud"
weight: 4
---

###### {$page.description}

<article id="1">

## What is Async.Executor?

Async.Executor is an object that wraps a piece of code to be executed asynchronously in Async.

Fundamentally, Async.Executor is a Func object that has `resolve` and `reject` methods.

</article>

<article id="2">

## How to Create an Async.Executor?

```javascript
public class HelloWorldExecutor extends Async.Executor {
    public HelloWorldExecutor() {
        super(0);
    }

    public override Object exec() {
        this.resolve('HelloWorld');
    }
}

Async promise = new Async(new HelloWorldExecutor());
```

</article>

<article id="3">

## Simplified Async.Executor

Most of the time we can use a Func as a simplified Async.Executor.

```javascript
public class HelloWorldFunc extends Func {
    public HelloWorldFunc() {
        super(0);
    }

    public override Object exec() {
        return 'HelloWorld';
    }
}

Async promise = new Async(new HelloWorldFunc());
```

</article>
