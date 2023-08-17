---
layout: blog
status: publish
published: true
url: /the-strategies-to-scale-nodejs/
title: The Best Strategies to scale Node.js Apps
description: This guide covers the three ways to scale an application:cloning, decomposition, and data sharding.
date: 2023-07-21T06:25:51-04:00
topics: [Performace, Node.js]
pick: [top]
excerpt_separator: <!--more-->
images:

  - url: /the-strategies-to-scale-nodejs/hero.png
    alt: Scaling Nodejs applications Boosting Nodejs app
---
They are many ways to scale an application. A single-instance (monolithic) Node.js app running on a single computer has three ways to scale: cloning, decomposition, and data sharding.
<!--more-->

#### Cloning

Cloning (also called forking) duplicates a Node.js application and runs multiple instances of the same application on a single machine, splitting traffic between those instances. Each instance is assigned part of the 
workload.

Cloning goes hand in hand with using a Node.js cluster module. The load balancer provides efficient performance when you clone your application. The load balancer distributes the traffic to multiple instances of your application and ensures that the workload is shared.

#### Decomposition

It’s hard to manage every service within a single codebase. Decomposing your monolithic application allows you to split the application’s services into independent microservices. Each microservice handles a service that the server needs to run.

A good example is a Node.js application providing a database and a front-end user interface. The database, front end, and back end can be split into microservices, letting you run each service independently.

The best model we currently have for decomposition is containerization. In this model, you decouple your app into multiple microservices and put each microservice in a container. Each container runs a single service, but creates high cohesion between the services.

#### Data sharding

Node.js scalability and availability rely heavily on the data capabilities of your application. Splitting data into meaningful subsets, often called shards, allows you to partition your disk space. This way, you split your application into instances that run across different machines or data centers.

Let’s assume your existing database can’t handle the amount of data being requested. Splitting your data is a highly recommended approach to scaling in this situation. You can split your database into several instances, each responsible for only a part of the whole data set. This kind of data distribution is also called horizontal partitioning.

Scaling out your application should be the primary objective of the shard. Deploying extra machines to an existing stack splits out the workload, improves traffic flow, and enables faster processing.

Some situations where sharding and horizontal database partitioning could be a good solution include:

- Your application starts to overflow the disk or memory space.
- The application performs too many write operations for one server.
- You need to speed up your database response time.
- You are experiencing application outages. If the application has outages with the potential to make the entire application unavailable, you can shard your data. This way, the outage will likely affect only a single shard rather than crashing the entire database.

### When should you scale your node.js app?

You need to monitor your application whenever it is running in an environment that might make high demands on it, to determine whether you need to change your scaling strategy. This section lists several symptoms of a poorly scaling application and suggests solutions.

#### High latency

High latency means a network call/request takes longer than expected. It often occurs intermittently, but is still a problem. Consider these [statistics](https://www.hobo-web.co.uk/your-website-design-should-load-in-4-seconds/#:~:text=The):

- The ideal application takes 1-2 seconds to load.
- A 2 seconds, application delay results in up to 87% user abandonment. (Check more related factors here ) About 50% of users leave apps that take more than 3 seconds to load.

Slow websites have a negative Google ranking index factor. Your application should load as fast as possible. It's up to you to test your application response time routinely without waiting for user complaints. You should always check any failed requests and the percentage of long-running requests. Any sign of high latency sends a warning that scaling is necessary.

#### CPUs running hot

A hot CPU is a good indicator that your application is utilizing the maximum available memory and cores in your machine. Your application is stretching the capacity of available cores to spawn processes. Users may start experiencing delays due to excessive load, resulting in requests taking more time than necessary. At this point, you should consider scaling strategies that fit your application's ability to scale out.

It's always advisable to keep an eye on your application's CPU and memory usage, rather than wait until the CPUs give you a hot signal. Use one the following tools to monitor your CPU usage:

- [HTOP](https://htop.dev/) for Unix systems.
- [Process Explorer](https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer) for Windows-based systems.
- The [Node.js native OS module](https://nodejs.org/api/os.html#os).

These tools let you check the load average for each core in real time. You can monitor usage, get a signal when problems are around the corner, and intervene before things get out of hand.

#### Too many WebSockets

WebSockets are used for efficient server communication over a two-way, persistent channel, and are particularly popular in  [real-time Node.js applications](https://www.simform.com/blog/build-real-time-apps-node-js/). The client and the server can communicate data with low latency.

WebSockets take advantage of Node.js's single-threaded event loop environment. Additionally, its asynchronous request processing architecture facilitates non-blocking I/O that executes requests without blocking. But Node.js can create so many concurrent executions that the number of sockets channels can grow beyond the capacity of a single node server.

Therefore, when using WebSockets with Node.js, issue io.sockets.clients() to get the number of the connected clients at any time and feed results to tracking and logging systems. You can scale your application to match your node’s capacity.

#### Too many file descriptors

A [file descriptor](https://nodejs.dev/en/learn/working-with-file-descriptors-in-nodejs/) is a non-negative integer used to identify an open file. Each application process records its own descriptors, and any time a new file is opened, an entry is recorded by the descriptors.

Each process is allowed a maximum number of file descriptors at any given time. If processes open too many files and start receiving “Too many open files” errors, scaling is called for. Adding servers can handle more files.

Check this [guide](http://woshub.com/too-many-open-files-error-linux/#:~:text=It%20means%20that%20a%20process,the%20values%20are%20rather%20small.) and learn handy approaches to maximizing the file descriptors limit for your application.

#### Event loop blockers

[Event loop](https://nodejs.org/ru/docs/guides/event-loop-timers-and-nexttick/) is a Node.js mechanism that handles events efficiently in a continuous loop. Even loop allows Node.js to perform [non-blocking I/O operations](https://nodejs.org/en/docs/guides/blocking-vs-non-blocking/). The following figure offers a simplified overview of the Node.js event loop based on the order of execution. Each process is referred to as a phase of the event loop.

![The Best Strategies to scale Node.js Apps](/the-strategies-to-scale-nodejs/loop.png)

Node.js uses the term event loop utilization to indicate the ratio between the amount of time the event loop is active in the event provider and the overall duration of its execution.

An event loop processes incoming requests fast. Each phase has a callback queue pointing to all the callbacks that must be handled during that phase. All the events are executed sequentially in the order they were received. The event loop continues until the queue is empty or the callback limit is exceeded. The event loop then progresses to the next phase.

Think about a callback that executes a CPU-intensive action without releasing the event loop. The event loop won't process any additional callbacks until it is free. Therefore, all others will stay in the queue. This roadblock is referred to as an event loop blocker. No incoming callback will be executed until the CPU-intensive operation completes. This has huge performance implications that need to be resolved. The solution is to mitigate the delay caused by the blockers.

You can use [Nginx Event Loop](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) as a grandmaster to successfully process millions of concurrent requests and scale your Node.js app. This way, you can detect whether the event loop is blocked longer than the expected threshold.