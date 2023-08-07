---
layout: blog
status: publish
published: true
url: /the-ultimate-guide-to-nodejs-clutering/
title: The Ultimate Guide to Node.js Clutering - How to use it in your Apps 
description: How Node.js creates a cluster to duplicate the application and scale it across the available CPUs with examples thata follows clustered Node.js app at work in a multi-core computer
date: 2023-07-21T06:25:51-04:00
topics: [Pragramming, Node.js]
excerpt_separator: <!--more-->
images: 

  - url: /the-ultimate-guide-to-nodejs-clutering/hero.png
    alt: The Ultimate Guide to Node.js Clutering
---

Clustering is an excellent and robust approach to multi-processing, running more than one Node instance. With multiple Node instances, you have numerous main threads. Thus even if one of the threads gets overloaded or crashes, the incoming requests are still handled by other threads.
<!--more-->

### The Beginning

There are two basic ways to handle more workload: inject more resources and processing capabilities into your existing infrastructure, or spread your application to resources that are already available and exploit the full power of a single machine.

Node.js is single-threaded. By default, it uses a single core of a processor, even though the computer could have multiple cores. Node.js can handle the application within that single core deftly. However, you are not utilizing the full processing power of your computer. Performing heavy tasks on a single CPU can lead to disasters such as [server deadlock](https://thesassway.com/how-to-avoid-deadlocks-in-node-js/).

If application loads create scaling risks, definitely consider scaling your Node.js application to use available resources. This approach is known as horizontal scaling.

The idea behind horizontal scaling is to duplicate your application instance to handle more incoming requests. This mechanism can be carried out on a single multi-core computer or multiple computers.

### Running multiple processes on the same machine

There are different approaches you can use and achieve these multi-processing capabilities in your Node.js apps. We’ll examine native cluster mode (which is built-in to Node.js and needs no extra library) and PM2.

#### Native cluster mode

To achieve horizontal scaling, Node.js creates a cluster to duplicate the application and scale it across the available CPUs. The following basic example shows a default Node.js single thread and a clustered Node.js app at work in a multi-core computer:

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/nodeje.multi-core-cpus.png)

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

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/heavytask.png)

Thus, sending a subsequent request to `http://localhost:3000/ligttask` won't return the expected response until the server finishes processing the first task and releases the CPU that handles both requests.

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/lighttask.png)

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

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/cpus.png)

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

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/report.png)

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

![The Ultimate Guide to Node.js Clutering](/the-ultimate-guide-to-nodejs-clutering/reportfast.png)

You can significantly note the change here. It took the server only 3 seconds to handle 10,000 requests.

#### PM2 cluster mode

Node.js also offers another way to achieve clustering. [PM2](https://pm2.keymetrics.io/) is a Node.js process manager that provides zero-downtime clusters.

To understand the benefits of PM2, think back to our example of the native cluster module. , That module required you to explicitly create and manage worker processes. You first needed to determine the number of available cores, and then determine how many workers to spawn.

The small example in the previous section added a substantial amount of code to manage the clustering within that small server. This means that on a production level, you need to manually write and manage the cluster. The module increases the complexity of the code you need to run to effectively utilize the available CPU cores.

As stated above, PM2 is a process manager that executes Node.js applications automatically in cluster mode. PM2 spawns workers for you and takes care of all processes you would have to manually implement with the native cluster module.

#### Choosing between native cluster and PM2

Clustering is and should be your first step toward scaling a Node.js application. You might want to go with the cluster module because it requires very little extra: add a few lines of code and you’re done. On the other hand, if you’re looking to avoid changing your code when you move it from machine to machine, and you need extra support for your production environment, PM2 should definitely be your choice.

**I hope you found this post helpful!!**