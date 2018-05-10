# Async.apex
Async.apex is a promise-like library to handle asynchronous Apex code neatly.

## Dependencies
Below dependencies have to be included to make Async.apex work.

- [R.apex](https://github.com/Click-to-Cloud/R.apex)


## Examples
### Then/Catch/Finally
```java
new Async(new CustomCodeFunc())
    .then(new Step1Func())
    .then(new Step2Func())
    .error(new ErrorHandleFunc())
    .done(new CleanupFunc())
    .fork();
```

### Promise Chaining
```java
Async.resolve(1)
    .then(new Return2Func()) // Return 2, executed synchronously
    .then(new ReturnAsyncFunc()) // Return new Async, executed asynchronously
    .then(new CustomCodeFunc()) // Handle the result from the new Async
    .fork();
```

### Functional Async
```java
Async.resolve(1) // 1
    .then(R.inc) // 1 + 1 = 2
    .then(R.multiply.apply(2)) // 2 * 2 = 4
    .then(R.debug) // print 4
    .fork();
```

### Error Recovery
```java
Async.reject('error') // error
    .error((Func)R.always.run(Async.resolve('success'))) // recover with success
    .then(R.debug) // success
    .fork();
```

## Get Started

### Preliminary Knowledge
Since Async.apex is based on [R.apex](https://github.com/Click-to-Cloud/R.apex), a fair amount of knowledge on R.apex is necessary to better understanding how Async.apex works.

### Async Executor
To create an Async by using an Async Executor, we will create an Executor first.

```java
public class HelloWorldExecutor extends Async.Executor {
    public HelloWorldExecutor() {
        super(0);
    }

    public override Object exec() {
        this.resolve('HelloWorld');
    }
}
```

Then we create an Async like this:

```java
Async promise = new Async(new HelloWorldExecutor());
```

Most of the time, we have an alternative, which is based on Funcs from R.apex.

```java
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

### Then/Catch/Finally
We have corresponding terms for *then/catch/finally* in Async.apex: *then/error/done*. Their usages are the same.

```java
promise.then(R.debug)
    .error(new ReportFunc())
    .done(new CleanupFunc())
    .fork();
```

**Important** is that differently from promises, Async instances are lazy, which means that we need to **fork** them to trigger the execution.

### Error Recovery
Just like promises, we can recover from errors by returning a new Async(promise).

```java
promise.error(new ReturnAsyncFunc()) // recover from errors
    .then(new CustomCodeFunc()) // continue logic
    .fork();
```

### Chaining
Funcs in then/error/done are executed synchronously. Only Async.Executor instances are executed asynchronously. That means that if we want to make a piece of code asynchronous, we will have to wrap it in Async.

```java
promise.then(new SyncCodeFunc()) // sync code
    .then(new ReturnAsyncFunc()) // async code executed in the returning Async
    .fork();
```

## Notice
Async.apex is implemented using Salesforce Apex Queueable jobs, so limitations on queueable jobs also apply here.
