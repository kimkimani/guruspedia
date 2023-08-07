---
layout: blog
status: publish
published: true
url: /understanding-the-concept-of-containers-and-containerization/
title: Understanding the Concept of Containers and Containerization
description: Containers are lightweight operating systems that run as a form of virtualization.  To understand how applications can benefit from this infrastructure, take an example of the old classic vitalization approach.
date: 2023-07-20T00:00:00-08:00
topics: [DevOps, Containers]
excerpt_separator: <!--more-->
images:

  - url: /understanding-the-concept-of-containers-and-containerization/hero.png
    alt: Understanding the concept of Containers and Containerization
---
Containers are lightweight operating systems that run as a form of virtualization.  To understand how applications can benefit from this infrastructure, take an example of the old classic vitalization approach.
<!--more-->

Once you have an app ready for production, you push it to a virtual machine on some host system. But to spin up this virtual machine, you need the following machine bare metals.

![Understanding the Concept of Containers and Containerization](/understanding-the-concept-of-containers-and-containerization/baremetals.png)

To depoly the application, you need a guest OS to spin up the virtual application. On top of that, you add some binaries and libraries to support your Node.js application.

![Understanding the Concept of Containers and Containerization](/understanding-the-concept-of-containers-and-containerization/node-virtul.png)

Once in production, you need to ensure the scalability of this application. Here we'll create two additional copies of the application.

![Understanding the Concept of Containers and Containerization](/understanding-the-concept-of-containers-and-containerization/guestvms.png)

Even though this can be a lightweight application, to create additional VMs, you have to deploy that guest OS, binaries, and libraries for each instance of the application. Here you can assume that you will have consumed all of the resources for this particular hardware.

Now assume that the application uses other software such as MySQL for database management. The architecture becomes even harder to manage. Each software hosts its own dependencies and libraries to manage. Some applications need -specific versions of libraries. This means that, even if you have a MySQL server running on your system, you still need to ensure you have the specific version that the Node.js app needs.

With such a huge number of dependencies to manage, you will end up in a [dependency matrix hell](https://sdtimes.com/containers/stuck-new-devops-matrix-hell/), unable to easily upgrade or maintain the software.

Assume that you developed the application on the Windows operating system. If you then deploy the application to a Linux system, incompatibilities are likely to turn up. Sharing the same copy of the application to different hosts can be challenging, as each host has to manually configure all the libraries and dependencies and ensure correct versioning is observed across the board.

Virtual machines are great for running applications that need OS-level features. However, deploying multiple instances of a single application that has a lightweight system can be hard to manage. You get the picture of how hard it can be to maintain your single Node.js application in such environments.

Containerization comes to the rescue to solve all these problems. Containerization lets you package your applications and run them in isolated environments. This gives you the power to run powerful applications quickly from different computing environments. 

Containerization provides a standardized, lightweight method to deploy your application to diverse infrastructures. In addition, you get a wide range of infrastructures that you can optionally choose to run your applications. Containers make it easier to build, ship, deploy, and scale applications with ease.

The following figure depicts how different Node.js instances can run within a containerized environment.

![Understanding the Concept of Containers and Containerization](/understanding-the-concept-of-containers-and-containerization/container.png)

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

Now that you have mastered the Concept of Containers and Containerization, why not dive deeper and learn the best strategies to slim Docker images and how to use them to reduce Docker image size in this [How to Minimize Docker Images - Docker Image Optimization Strategies](https://guruspedia.com/how-to-minimize-docker-mages/) guide.

### Conclusion

This post explored potential approaches for scaling Node.js. Before choosing container techniques to use, ensure you scrutinize your application to get insight into the optimal strategy.