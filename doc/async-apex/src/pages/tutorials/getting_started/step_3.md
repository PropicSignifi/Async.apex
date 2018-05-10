---
title: "Async Executor"
description: "Async Executor"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 3
---

## {$page.title}

An Async.Executor is a piece of code that runs asynchronously. In Async.apex, all codes that run asynchronously need to be placed in Async.Executor.

To create an Async by using an Async Executor, we will create an Executor first.

```javascript
public class HelloWorldExecutor extends Async.Executor {
    public HelloWorldExecutor() {
        super(0);
    }

    public override Object exec() {
        this.resolve('HelloWorld');
    }
}
```

Async.Executor is somehow similar with Func, right? It is because Async.Executor is just a subclass of Func. The difference lies in that Async.Executor provides two extra methods: `resolve` and `reject`.

By invoking `this.resolve(Object)`, we notify the Async with the success value, while by invoking `this.reject(Object)` we notify the Async with the error.

Then we create an Async like this:

```javascript
Async promise = new Async(new HelloWorldExecutor());
```

Most of the time, we have an alternative, which is based on Funcs from R.apex.

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

These two version are equivalent.
