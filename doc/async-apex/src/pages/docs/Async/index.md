---
title: "Async"
description: "Async"
layout: "guide"
icon: "flash"
weight: 1
---

###### {$page.description}

<article id="1">

## What is an Async?

Async are just promises that are executed lazily.

A promise wraps a piece of asynchronous code and resolves the value from the code when it's done.

Here is what a promise would look like.

```javascript
new Promise(promiseExecutor)
    .then(successHandler)
    .catch(errorHandler)
    .finally(cleanupHandler);
```

And in Async.apex:

```javascript
new Async(new CustomAsyncExecutor())
    .then(new SuccessHandler())
    .error(new ErrorHandler())
    .done(new CleanupHandler())
    .fork();
```

</article>

<article id="2">

## Async Status

Async has three statuses.

| Status | Description |
| ------ | ----------- |
| Pending | Asynchronous code is not executed, or is being executed |
| Fulfilled | Asynchronous code has been executed, and result is set back |
| Rejected | Asynchronous code has been executed, and error is set back |

Normally a new Async is set with status as pending. When the execution is successful, Async status changes to fulfilled. Otherwise, it changes to rejected.

</article>

<article id="3">

## Async Trigger

Async is a lazy promise and it is only triggered when `fork` is invoked.

```javascript
new Async(new AsyncFunc())
    .fork(); // pull the trigger
```

</article>

<article id="4">

## Async Chaining

We can chain asynchronous codes by returning a new Async in `then`/`error`/`done`.

```javascript
new Async(new AsyncCode1()) // Code in AsyncCode1 is executed asynchronously
    .then(new AsyncCode2()) // AsyncCode2 needs to return a new Async that wraps the code to be executed asynchronously
    .fork();
```
</article>

<article id="5">

## Limitations

Async.apex uses Apex queueable jobs behind the scene. So all limitations on Apex queueable jobs also apply to Async.apex.

</article>
