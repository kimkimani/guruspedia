---
layout: blog
status: publish
published: true
url: /cancelling-coroutines-in-kotlin/
title: Guide to Cancelling Coroutines in Kotlin
description: This guide will help you learn how to cancel Coroutines in Kotlin
date: 2023-07-23T15:02:24-04:00
topics: [Kotlin]
excerpt_separator: <!--more-->
images:

  - url: /cancelling-coroutines-in-kotlin/hero.png
    alt: Guide to Cancelling Coroutines in Kotlin
---

[Coroutines](https://kotlinlang.org/docs/coroutines-basics.html) are lightweight threads that allow you to execute tasks without blocking your application's main thread. Coroutines simplify these tasks and ensure they run asynchronously. This ensures you run non-blocking code that executes fast while still running intensive tasks.
<!--more-->

### Intro

Whenever you launch a Coroutine, you execute a job. It is always advisable to avoid doing more work than is actually needed. An example is a Coroutine execution that performs a long task (expensive computation).

Chances are, such tasks may fail prematurely during an execution. Based on how you wrote your Coroutine lifecycle, this task can periodically still continue to run without your knowledge. Your application will still receive an expected result.

Given that it's an expensive computation that has failed prematurely, your application may actually be forced to do more unnecessary execution that can slow down your application or become a potential memory leak.

When executing these jobs, Coroutine provides important mechanisms to perform Coroutine cancellation. This allows to kill threaded executions to close unsuccessful jobs and free resources. This guide will help you learn how to cancel Coroutines in [Kotlin](https://kotlinlang.org/).

### Prerequisites

To fully understand the concept of Coroutine cancellation, ensure you have the basic level knowledge of:

- How Coroutines works
- How to write Coroutines in Kotlin
- Ensure you have the Coroutines dependencies

### A Coroutine scope

Assume you are executing a Coroutines with two scopes. In this case, you want to cancel each scope without affecting the execution of the other scopes. However, if you cancel a scope, the whole Coroutine will be cancelled, and terminate the two scopes.

Take this example that executes two jobs:

```kotlin
funScopeAndJob() {

val scope =CoroutineScope(Job())

val job1 = scope.launch {

try {

delay(500)

println("First Job")

} catch (e: CancellationException) {

e.printStackTrace()

}

}

val job2 = scope.launch {

delay(500)

println("Second Job")

}

Thread.sleep(1000)

println("End of CoroutineScope")

}
```

This case has two scopes. When the `ScopeAndJob()` gets called, the application will execute the two jobs as expected.

```bash
Second Job

First Job

End of CoroutineScope
```

However, assume you want to cancel your job. A key point to note is that both jobs get terminated when you use `cancel()` with the scope. Go ahead and call scope `cancel()` inside `ScopeAndJob()` And execute your `main` function.

```bash
End of CoroutineScope
```

In this instance, every job got eliminated. Your goal remains to ensure that if a single job gets terminated, this does not affect the execution of other Coroutines within this scope.

You only need to call `cancel()` on that single active job object. If that job gets terminated, the execution of other jobs still runs as expected.

To test this, go ahead and add `job1.cancel()` to the `ScopeAndJob()` function and execute your code block.

```bash
Second Job

End of CoroutineScope
```
In this case; the second job was executed—the first job was cancelled without affecting other Coroutines.

### Conclusion

Assume you have a job that makes a network request. If there are some internet failures or the Network API is not responding, you need to cancel that job to avoid performance overheads to unresponsive internet calls. Using Coroutines to cause such task becomes very handle. You only need a few lines of code to make your jobs cancelable. Guide to Cancelling Coroutines in Kotlin