---
title: "Methods"
description: "Async Methods"
layout: "guide"
icon: "code-file"
weight: 2
---

###### {$page.description}

<article id="1">

## How to Create an Async?

Below are all the ways to create an Async.

| Method | Description |
| ------ | ----------- |
| new Async(Async.Executor) | Create an Async with an Async.Executor |
| new Async(Func) | Create an Async with a Func |
| Async.resolve(Object) | Create a resolved Async returning the value |
| Async.reject(Object) | Create a rejected Async returning the error |

</article>

<article id="2">

## How to Query an Async?

| Method | Description |
| ------ | ----------- |
| isPending() | Check if the Async is pending |
| isResolved() | Check if the Async is fulfilled |
| isRejected() | check if the Async is rejected |

</article>

<article id="3">

## How to Chain an Async?

| Method | Description |
| ------ | ----------- |
| then(Func, Func) | Add the success handler and the error handler |
| then(Func) | Add the success handler |
| error(Func) | Add the error handler |
| done(Func) | Add the handler as the success handler and error handler |
| fork() | Trigger the Async to execute |

</article>
