---
layout: blog
status: publish
published: true
url: /best-performance-practices-for-scaling-nodejs-applications/
title: Best Performance Practices for Scaling Node.js applications:Boosting Node.js app
description: This guide covers the best practices and solutions in hand for scaling Node.js apps. Buckle up and get ready to boost your Node.js APIs like a pro.
date: 2023-07-20T00:00:00-01:00
topics: [Performace]
pick: [top]
excerpt_separator: <!--more-->
images:

  - url: /best-performance-practices-for-scaling-nodejs-applications/hero.png
    alt: Scaling Nodejs applications Boosting Nodejs app
---
Scalability is a broad and inclusive concept, tailored for diverse contexts and applications. This guide covers the best practices and solutions in hand for scaling Node.js apps. Buckle up and get ready to boost your Node.js APIs like a pro.
<!--more-->

Node.js is the most popular backend technology for creating APIs. Node.js runs on [Google’s V8 engine](https://v8.dev), one of the fastest JavaScript engines in existence. At its core, Node.js exclusively exploits its own infrastructure to create applications that scale.

Scalability indicates the capacity of an application to handle workloads at both extremes: If the application has a steady growth of resource demand, it should scale up and create room for the high incoming traffic. Correspondingly, when traffic declines, the application should scale down and release resources that are not needed at that given time.

### Horizontally scaling your Node.js app

There are two basic ways to handle more workload: inject more resources and processing capabilities into your existing infrastructure, or spread your application to resources that are already available and exploit the full power of a single machine.

Node.js is single-threaded. By default, it uses a single core of a processor, even though the computer could have multiple cores. Node.js can handle the application within that single core deftly. However, you are not utilizing the full processing power of your computer. Performing heavy tasks on a single CPU can lead to disasters such as [server deadlock](https://thesassway.com/how-to-avoid-deadlocks-in-node-js/).

If application loads create scaling risks, definitely consider scaling your Node.js application to use available resources. This approach is known as horizontal scaling.

The idea behind horizontal scaling is to duplicate your application instance to handle more incoming requests. This mechanism can be carried out on a single multi-core computer or multiple computers.

### Running multiple processes on the same machine

There are different approaches you can use and achieve these multi-processing capabilities in your Node.js apps. We’ll examine native cluster mode (which is built-in to Node.js and needs no extra library) and PM2.


#### Native cluster mode

To achieve horizontal scaling, Node.js creates a cluster to duplicate the application and scale it across the available CPUs. A basic example follows of a default Node.js single thread and a clustered Node.js app at work in a multi-core computer:

![](/best-performance-practices-for-scaling-nodejs-applications/nodeje.multi-core-cpus.png)

Clustering is an excellent and robust approach to multi-processing, running more than one Node instance. With multiple Node instances, you have numerous main threads. Thus even if one of the threads gets overloaded or crashes, the incoming requests are still handled by other threads.

To evolve beyond the Node.js default of single-thread execution, a [built-in cluster module](https://nodejs.org/api/cluster.html#cluster) was introduced to allow execution on multiple processor cores. This native module requires just a few extra lines of code. The module duplicates the application to different cores.

Using this module, you can scale up by creating worker processes (child processes). Using this approach, the application runs its main process, called the master process, at launch. It then forks the application to [worker processes](https://nodejs.org/api/cluster.html#class-worker).

Worker processes listen for requests on a single port, through which all requests are routed. The Node.js cluster module runs an embedded load balancer to distribute requests among the available worker processes. This makes the native module ideal for handling a larger number of requests.

Implementing clustering in Node.js is pretty simple. Let's dive in, write a few lines of code, and see how the native cluster module works.

First, try out a simple Node.js server that processes some heavy requests without using clustering. This example executes a default, single-thread Node.js server:

```javascript
const express = require("express")
const app = express();

app.get("/heavytask", (req, res) =>{
    let counter = 0;
    while (counter<9000000000){
        counter ++;
    }
    res.end(`${counter} Iteration request completed`)
})

app.get("/ligttask", (req, res) =>{

    res.send("A simple HTTP request")

})

app.listen(3000, () => console.log("App listening on port 3000"))
```

Note that the first request iterates over a large number and can take some time to execute. In contrast, another returns a simple basic request. You can test both endpoints using Postman. Sending a request to `http://localhost:3000/heavytask` blocks the application execution thread.

![](/best-performance-practices-for-scaling-nodejs-applications/heavytask.png)

Thus, sending a subsequent request to `http://localhost:3000/ligttask` won't return the expected response until the server finishes processing the first task and releases the CPU that handles both requests.

![](/best-performance-practices-for-scaling-nodejs-applications/lighttask.png)

```javascript
To solve this problem, you can use the cluster module as follows:
const express = require("express")
const cluster = require("cluster");
const os = require('os')

// check if the process is the master process
if(cluster.isMaster){
    // get the number of available CPU cores 
    const CPUs = os.CPUs().length;
    // fork worker processes for each available CPU core
    for(let i = 0; i< CPUs; i++){
        cluster.fork()
    }
    // The of the number of cores
    console.log(`Available CPUs: ${CPUs}`)

    cluster.on("online",(worker, code, signal) => {
        console.log(`worker ${worker.process.pid} is online`);
      });

}else{
    const app = express();
    // if the process is a worker process, listen for requests
    app.get("/heavytask", (req, res) =>{
        let counter = 0;
        while (counter<9000000000){
            counter ++;
        }
        // Log the core that will execute this request
        process.send(`Heavy request ${process.pid}`)
        res.end(`${counter} Iteration request completed`)
    })
    
    app.get("/ligttask", (req, res) =>{
        // Log the core that will execute this request
        process.send(`Light request ${process.pid}`)
        res.send("A simple HTTP request")
    
    })
    
    app.listen(3000, () => {
        console.log(`worker process ${process.pid} is listening on port 3000`);
    });
}
```

Go ahead and run the above script. In my case, I have the following results.

![](/best-performance-practices-for-scaling-nodejs-applications/cpus.png)

The computer has 8 cores. They are all mapped to the same port and ready to listen for connections. Each core used runs Google’s V8 engine, letting your application run even faster. If you test the endpoint again, the light task will be executed immediately while the heavy task is being handled by the core it is assigned to.

We can measure the benefits of using available cores. Let’s assume you have an application that expects 10,000 requests from about 100 users in production. Using the previous example as an illustration, you can spawn the request to all available cores. The following example tests the Node.js application and simulates the ideal execution on production:

Without the cluster:

```javascript
const express = require("express")
const app = express();

app.get("/", (req, res) =>{

    res.send("A simple HTTP request")

})

app.listen(3000, () => console.log("App listening on port 3000"))
```

Go ahead and run the server. Then run the following command to stimulate [Autocannon](https://www.npmjs.com/package/autocannon) for a production Node.js app:

```bash
npx autocannon -c 100 -a 10000 http://localhost:3000/
```

![](/best-performance-practices-for-scaling-nodejs-applications/report.png)

It took about 7 seconds to execute 10,000 requests. Let’s see whether there is any change when you use clustering on a 4-core computer.

With the Node.js Cluster module:

```javascript
const express = require("express")
const cluster = require("cluster");
const os = require('os')

// check if the process is the master process
if(cluster.isMaster){
    // get the number of available CPU cores 
    const CPUs = os.CPUs().length;
    // fork worker processes for each available CPU cores
    for(let i = 0; i< CPUs; i++){
        cluster.fork()
    }

}else{
    const app = express();
    // if the process is a worker process listen for requests

    app.get("/", (req, res) =>{
        // Log the core that will execute this request
    
        res.send("A simple HTTP request")
    
    })
    
    app.listen(3000, () => {
        console.log(`worker process ${process.pid} is listening on port 3000`);
    });
}
```

![](/best-performance-practices-for-scaling-nodejs-applications/reportfast.png)

You can significantly note the change here. It took the server only 3 seconds to handle 10,000 requests.

#### PM2 cluster mode

Node.js also offers another way to achieve clustering. [PM2](https://pm2.keymetrics.io/) is a Node.js process manager that provides zero-downtime clusters.

To understand the benefits of PM2, think back to our example of the native cluster module. , That module required you to explicitly create and manage worker processes. You first needed to determine the number of available cores, and then determine how many workers to spawn.

The small example in the previous section added a substantial amount of code to manage the clustering within that small server. This means that on a production level, you need to manually write and manage the cluster. The module increases the complexity of the code you need to run to effectively utilize the available CPU cores.

As stated above, PM2 is a process manager that executes Node.js applications automatically in cluster mode. PM2 spawns workers for you and takes care of all processes you would have to manually implement with the native cluster module.

#### Choosing between native cluster and PM2

Clustering is and should be your first step toward scaling a Node.js application. You might want to go with the cluster module because it requires very little extra: add a few lines of code and you’re done. On the other hand, if you’re looking to avoid changing your code when you move it from machine to machine, and you need extra support for your production environment, PM2 should definitely be your choice.

### Running across multiple machines with network load balancing

Clustering allows you to horizontally scale your application in a single machine across multiple cores. You can also distribute your application instances across multiple machines. This will horizontally scale across multiple machines rather than on a single multicore machine.

This approach is comparable to how the cluster module directs traffic to the child worker process. However, here you are distributing the application traffic across multiple servers that run the same instance of your application. Independent processes of your application can still run using multiple machines.

To scale across multiple machines, you need a [load balancer](https://medium.com/techintoo/load-balancing-node-js-51b854fb4f4f). An algorithm for distributing priorities and identifying the server with the least workload(traffic) or the quickest response time.

![](/best-performance-practices-for-scaling-nodejs-applications/loadbalancer.png)

A load balancer serves as your "traffic cop" in front of your servers. It distributes client requests across all servers capable of handling them. This simultaneously optimizes speed and greater resilience.

A load balancer achieves this by ensuring no server is overwhelmed, which could cause performance degradation. If a server goes offline or crashes load balancer redirects traffic to the active servers. And if a new server is added, the load balancer forwards requests to the new server.

[NGINX](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/) is a popular tool for implementing load balancing in Node.js. Nginx is an Open-Source utility for configuring HTTP and HTTPS servers for traffic distribution.

### Containerization to the rescue

Containers are lightweight operating systems that run as a form of virtualization.

To understand how applications can benefit from this infrastructure, take an example of the old classic vitalization approach. Once you have an app ready for production, you push it to a virtual machine on some host system. But to spin up this virtual machine, you need the following machine bare metals.

![](/best-performance-practices-for-scaling-nodejs-applications/baremetals.png)

To depoly the application, you need a guest OS to spin up the virtual application. On top of that, you add some binaries and libraries to support your Node.js application.

![](/best-performance-practices-for-scaling-nodejs-applications/node-virtul.png)

Once in production, you need to ensure the scalability of this application. Here we'll create two additional copies of the application.

![](/best-performance-practices-for-scaling-nodejs-applications/guestvms.png)

Even though this can be a lightweight application, to create additional VMs, you have to deploy that guest OS, binaries, and libraries for each instance of the application. Here you can assume that you will have consumed all of the resources for this particular hardware.

Now assume that the application uses other software such as MySQL for database management. The architecture becomes even harder to manage. Each software hosts its own dependencies and libraries to manage. Some applications need -specific versions of libraries. This means that, even if you have a MySQL server running on your system, you still need to ensure you have the specific version that the Node.js app needs.

With such a huge number of dependencies to manage, you will end up in a [dependency matrix hell](https://sdtimes.com/containers/stuck-new-devops-matrix-hell/), unable to easily upgrade or maintain the software.

Assume that you developed the application on the Windows operating system. If you then deploy the application to a Linux system, incompatibilities are likely to turn up. Sharing the same copy of the application to different hosts can be challenging, as each host has to manually configure all the libraries and dependencies and ensure correct versioning is observed across the board.

Virtual machines are great for running applications that need OS-level features. However, deploying multiple instances of a single application that has a lightweight system can be hard to manage. You get the picture of how hard it can be to maintain your single Node.js application in such environments.

Containerization comes to the rescue to solve all these problems. Containerization lets you package your applications and run them in isolated environments. This gives you the power to run powerful applications quickly from different computing environments. 

Containerization provides a standardized, lightweight method to deploy your application to diverse infrastructures. In addition, you get a wide range of infrastructures that you can optionally choose to run your applications. Containers make it easier to build, ship, deploy, and scale applications with ease.

The following figure depicts how different Node.js instances can run within a containerized environment.

![](/best-performance-practices-for-scaling-nodejs-applications/container.png)

With containers, you don’t need a guest OS to run your application. The container shares the host’s kernel to run all the individual apps within the container. Resources are shared within the container, and your application consumes less resources. If these container processes aren't actually utilizing the CPU or memory, those shared resources become accessible to the other containers running within that hardware.

And if you have an additional service that Node.js needs, such as a MySQL server, you need only one container to run the service. The instance will then be shared among all the running services that require it.

Containers isolate a process as opposed to a machine. This increases your application’s availability and the easy scalability of available resources. Containers increase application portability and compatibility. This means if the application runs in one environment, it will run as expected in another. All you need is to share the specific container for the environment, which will export all the needed dependencies. A container has all the right versions of the libraries it needs to run, ensuring portability across environments.

In short, containers give you the following advantages:

- Consistent environments, meaning you can choose the languages and dependencies you want for your project without worrying about system conflicts.
- Easier to scale out.
- Process isolation, making it easier to troubleshoot issues.
- Build once, deploy anywhere, which allows you to package and share your code with other teams and environments.
- Strong support for DevOps and continuous integration/continuous delivery (CI/CD).
- Support for automation, improving your developer experience.
- Autoscaling cron jobs, freeing you from watching your application all the time. With a few steps, you can [create autoscaling jobs that will handle container](https://techbeacon.com/enterprise-it/scaling-containers-essential-guide-container-clusters) scalability for you.


The top 10 Container Management Software include:

- Docker
- AWS Fargate
- Google Kubernetes Engine
- Amazon ECS
- LXC
- Container Linux by CoreOS
- Microsoft Azure
- Google Cloud Platform
- Portainer
- Apache Mesos

### Strategies to scale Node.js

They are many ways to scale an application. A single-instance (monolithic) Node.js app running on a single computer has three ways to scale: cloning, decomposition, and data sharding.

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

![](/best-performance-practices-for-scaling-nodejs-applications/loop.png)

Node.js uses the term event loop utilization to indicate the ratio between the amount of time the event loop is active in the event provider and the overall duration of its execution.

An event loop processes incoming requests fast. Each phase has a callback queue pointing to all the callbacks that must be handled during that phase. All the events are executed sequentially in the order they were received. The event loop continues until the queue is empty or the callback limit is exceeded. The event loop then progresses to the next phase.

Think about a callback that executes a CPU-intensive action without releasing the event loop. The event loop won't process any additional callbacks until it is free. Therefore, all others will stay in the queue. This roadblock is referred to as an event loop blocker. No incoming callback will be executed until the CPU-intensive operation completes. This has huge performance implications that need to be resolved. The solution is to mitigate the delay caused by the blockers.

You can use [Nginx Event Loop](https://www.nginx.com/blog/thread-pools-boost-performance-9x/) as a grandmaster to successfully process millions of concurrent requests and scale your Node.js app. This way, you can detect whether the event loop is blocked longer than the expected threshold.

### Conclusion

Scaling is the optimal solution to ensure that your Node.js application runs at its best. Scaling is a continuous activity, so you need to know when to scale based on your application’s architecture and behavior.
Oher additional practices that you can consider to create optimal Node.js apps include:

- Serving Node.js static assets with Nginx.
- Using caching strategies such as Redis to reduce application lookups.
- Database query optimization. Ensure that database queries are as efficient as they can be, and that they do not add too much server latency.
- Tracking down memory leaks to ensure the running services don’t hold on to memory unnecessarily. A garbage collector allows you to analyze memory leaks.
- Real-time monitoring and logging to analyze and get real-time metrics on your Node.js application's performance.
- Enhancing data processing strategies. For example, consider using pagination in your Node.js API or creating a Node.js application with optimal server strategy, such as building Node.js with gRPC to resolve the requests from the gateway to the server. Or use GraphQL to reduce payloads in server responses and net traffic.

This post explored potential approaches for scaling Node.js. Before deciding which optimization techniques to use, ensure you scrutinize your application to get insight into the optimal strategy.