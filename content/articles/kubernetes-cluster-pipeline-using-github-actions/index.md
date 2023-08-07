---
layout: blog
status: publish
published: true
url: /kubernetes-cluster-pipeline-using-github-actions/
title: Deploy Kubernetes CICD pipeline using GitHub Actions and EKS
description: This guide will teach you how to create a GitHub Actions workflow that automates EKS Kubernetes deployment using GitHub.
date: 2023-07-26T03:28:29-04:00
topics: [DevOps]
pick: [top]
excerpt_separator: <!--more-->
images:

  - url: /kubernetes-cluster-pipeline-using-github-actions/hero.png
    alt: Kubernetes Cluster CI/CD pipeline Deployments using GitHub Actions and EKS
---

In this tutorial, you will go through the steps of automating Kubernetes deployment with GitHub Actions. This guide will teach you how to create a GitHub Actions workflow that automates [Kubernetes deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) using GitHub.
<!--more-->

### Introduction 

Kubernetes is a powerful container orchestration tool for managing containerized applications. Its features simplify deployment processes and how you manage your application workloads. A CI/CD pipeline creates a frequent code integration environment. A CI/CD automates how you deploy an application to production with reproducible builds and faster deployments.

[GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) is a popular tool that allows you to create automated CI/CD pipelines to build, test, and deploy your code from a GitHub repository. It triggers builds based on changes you add to your GitHub repository to ensure applications work as expected and are always up-to-date.

A Kubernetes deployment consists of a set of specifications that define how your application should be deployed and managed. The deployment specifies the desired deployment objects, such as [replicas and containers](https://earthly.dev/blog/use-replicasets-in-k8s/).

### Prerequisites

To follow along with this tutorial:
- Ensure you have a basic understanding of [Kubernetes](https://kubernetes.io/docs/home/) and [GitHub Actions](https://docs.github.com/en/actions/learn-github-actions)
- A ready working application. This can be an application of your choice with all the source code and dependencies required to run it on your local machine. However, you can make use of the application on this [GitHub repository](https://github.com/Rose-stack/GitHub-Actions-K8s)  if you don’t have one.
- A working knowledge of [Docker](https://earthly.dev/blog/docker-virutal-machines/).

> RELATED: [Creating Dockerfile: Tips to slim Docker images using Dockerfiles](https://guruspedia.com/how-to-minimize-docker-mages/)

- An [IAM user created and configured using AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) as this guide will use the AWS Elastic Kubernetes Serivice (EKS) to provision a Kubernetes cluster.
Familiarity with [GitHub to host code repositories](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github).

### Addressing Kubernetes Deployment Challenges with GitHub Actions

Creating and managing Kubernetes deployment can be a little bit challenging. These challenges include:

- Manual intricacy that creates error-prone deployments,
- Configuration drift that makes the actual state of the deployed resources differs from the desired state,
- Versioning challenges, particularly if you need to roll back to a previous version in case of application failures.

To address these challenges, the DevOps team needs a workflow optimised for K8s deployments. Tools such as GitHub Actions manage applications and implement automated deployment processes. GitHub Actions provides a reliable continuous delivery pipeline to minimise these challenges.

This pipeline uses version control systems like GitHub to implement continuous deployments. GitHub Actions create reusable actions in your workflows. The actions connect your integrated Kubernetes workflow to release products more often without compromising quality.

When you make changes to your repository, the reproducible steps defined in your GitHub Actions workflows are triggered, initiating redeployments through your established pipeline. This ensures that any modifications to your codebase are automatically deployed, following the defined workflow, without manual intervention.

![GitHub Actions and EKS: GitHub Action workflow for Kubernetes](/kubernetes-cluster-pipeline-using-github-actions/cicd.png)

### Setting up Kubernetes Cluster

To create your Kubernetes CI/CD pipeline, you will need a working Kubernetes Cluster — which  is a group of machines, called nodes, that collectively run containerized applications managed by Kubernetes. This cluster can be created locally or on a cloud service provider like Amazon Elastic Kubernetes Service (EKS) on AWS. 

#### Creating a Working Application

To create a Kubernetes cluster, you need a working application.  This can be an application of your choice with all the source code and dependencies required to run it on your local machine.
This guide uses a simple Node.js application which you can find on this [GitHub repository](https://github.com/Rose-stack/GitHub-Actions-K8s)

#### Creating the Docker Application

Your application must be packaged using [Docker](https://earthly.dev/blog/docker-virutal-machines/) before you can manager it with Kubernetes.  Docker creates a custom image for your application and packages your code and the dependencies needed to run it. Below is a simple `Dockerfile` that this guide will use to create an image for a Node.js application:

```dockerfile
#Stage One: Base
FROM node:19-alpine AS base
WORKDIR /app
COPY package.json ./
COPY package-lock.json ./

#Stage Two: Final
FROM base AS final
RUN npm install --production
COPY ./ ./
EXPOSE 3000
CMD npm start
```
This Dockerfile creates a Docker image using [multi-stage build](https://earthly.dev/blog/minimize-docker-images-size/#using-multistage-builds-to-slim-docker-images). It separates dependencies installation. The `base` stage installs all dependencies for development purposes, and the `final` stage only installs production dependencies, copies the necessary files, and runs the application.

#### Creating the Manifest Files

Kubernetes uses [manifest files](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/) to define and manage deployments. A Kubernetes manifest is a YAML file that contains the necessary deployment objects and resources to run a Kubernetes cluster.

The configuration below is a Kubernetes YAML manifest file that defines a Deployment resource that defines the desired state and configuration of a deployment:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-deployment
  namespace: default
  labels:
    app: test-api
spec:
  selector:
    matchLabels:
      app: test-api
  replicas: 3
  template:
    metadata:
      labels:
        app: test-api 
    spec:
      containers:
      - name: node-api
        image: rosechege/sample_image:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 3000
      restartPolicy: Always
```

The provided YAML manifest describes a Kubernetes Deployment resource named `k8s-deployment` in the `default` namespace. It specifies that three replicas of a container named `node-api` should be created. The container uses the image `rosechege/sample_image:latest` that will be created by the Docker image above.  The container listens on port 3000, and the deployment ensures that the latest image version is always pulled. If a pod crashes or terminates, it will be automatically restarted. The Deployment is labeled as "app: test-api" to identify and organize the resources.

#### Adding Application Code to GitHub

At this point you should have your application code, Dockerfiles and Kubernetes manifest ready. You will need to add this to your GitHub repository as GitHub Actions requires you to have code applications on GitHub. 

Your application file structure should look as shown below:

```bash
\---app
    |   app.js
    |   Dockerfile
    |   dockerignore
    |   k8s_deployment.yml
    |   package-lock.json
    |   package.json
```

[Push](https://docs.github.com/en/get-started/using-git/pushing-commits-to-a-remote-repository) the files to your GitHub repository.

### Docker Images with GitHub Actions

Kubernetes manage and orchestrate Docker containers. When deploying applications on Kubernetes, you need to build a Docker image based on your application's Dockerfile. Once the image is built, you can push it to a container registry. Kubernetes can then pull the image from the container registry and use it to create and manage containers within a cluster, ensuring that the desired number of replicas are running based on the specified configuration.

An image registry stores the image of your packaged application. The image registry can be any of the following:

- [DockerHub](https://hub.docker.com/)
- [GitHub Container Registry](https://github.blog/2020-09-01-introducing-github-container-registry/)
- [AWS Elastic Container Service (ECS)](https://aws.amazon.com/ecs/)
- [Azure Container Registry](https://azure.microsoft.com/en-us/products/container-registry)

All these container registries handle Docker container images. They store and manage your docker images, which Kubernetes can access remotely and spin a cluster. GitHub Actions can also access any of the above container registries and automatically build and push the image to any of it that you specified. In this example, you will use GitHub Actions to push the image to [DockerHub](https://hub.docker.com/).

GitHub Actions uses events to automate the building and pushing of Docker images. These events act as triggers for workflows, defining specific activities and actions within your code repository. You can refer to the GitHub Actions documentation on [events that trigger workflows](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows) and [triggering a workflow](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow) for more detailed information on how events work and how they can be used to orchestrate actions within your development process.

With this in mind, let’s create a workflow to build and push the image to DockerHub.

However, before we proceed, it’s important to note that container registries are private. This means that to access images stored on them, GitHub must have the correct access to the registry. While using DockerHub, GitHub requires your [DockerHub username and secret key to establish communication](https://docs.docker.com/docker-hub/access-tokens/) and connect to your set pipeline. So ensure you have these details ready before proceeding with the workflow setup.

Since these details are sensitive data, You need to add them to GitHub actions as environment [secrets](https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28) that shouldn't be exposed to your remote GitHub repository.

To create these environment secrets, navigate to the **Settings** page of your GitHub repository and click on  **Secrets and Variables**. Select for **Actions**, then click on the create **New repository secret*. This way, sensitive configuration data will be executed as environment secrets during the CI runtime.


You can checkout [this article](https://earthly.dev/blog/github-actions-environment-variables-and-secrets) on managing environment variables on GitHub.

Add the following as the repository secrets:

- DOCKERHUB_USERNAME - this should be the username for your DockerHub account
- DOCKERHUB_TOKEN - it is a generated secret key for your DockerHub account. 

Check this [guide and create your key](https://docs.docker.com/docker-hub/access-tokens/).

Once you have them ready, the following image summarizes the complete steps and results for your environment variables configuration:

![GitHub Actions and EKS: Setting up GitHub actions environment variables](/kubernetes-cluster-pipeline-using-github-actions/variables.png)

#### Laying Down the Workflow

GitHub Actions automatically detects a  `.github/workflows` directly to trigger CI/CD process. Ensure your GitHub repository has a `.github/workflows` folder and create a `deploy.yml` [workflow configuration file](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow) in the folder:

![Creating GitHub actions file](/kubernetes-cluster-pipeline-using-github-actions/action.png)

The content of the `deploy.yml` will describe what triggers your pipeline and what action should be performed when the pipeline is triggered. GitHub actions listen to changes in your code repository to trigger the pipeline. Therefore, you must tell GitHub actions what action will automatically trigger your pipeline whenever there are new added changes. 
Add the following code in your `.github/workflows/deploy.yml` file:

```yml
name: Kubernetes CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```

In the above code, the `on` section specifies when the pipeline will be triggered. The pipeline is triggered on two events:

- When code is pushed to the `main` branch of the repository.
- When a pull request is made to the `main` branch of the repository.

To run your workflow, GitHub action needs a build machine where [task/job](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow) where your pipeline runs on. You can specify this as follows:

```yml
jobs:
  k8s_deployment:
    runs-on: ubuntu-latest
```

The above code specifies that the job named "k8s_deployment" should be run on a machine with the latest version of Ubuntu.

This virtual machine hosts the application code and creates an environment for running the commands GitHub action requires. However, the machine cannot access your code, which is only available on your GitHub code repository. Therefore, you need to clone the code to your build machine as follows:

```yml
jobs:
  k8s_deployment:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
```

The above code specifies a step in the "k8s_deployment" job that checks out the code from your GitHub repository and clones it to the build machine for use in subsequent steps.

#### Building and pushing Docker images with GitHub Actions

Now, we discuss the process of building and pushing your custom Docker image to DockerHub with GitHub Actions. As discussed earlier, GitHub action needs to authenticate to DockerHub to manage your docker images. To authenticate to DockerHub, Your machine will first login to DockerHub using the following GitHub action workflow:

```yml
    steps:
      - name: Checkout Code
        uses: actions/checkout@v2
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
```

The workflow sets the `username` value as the `DOCKERHUB_USERNAME` secret and the `password` value as the `DOCKERHUB_TOKEN` which you generated earlier.
The workflow uses the `docker/login-action@v2` action and environment secrets to authenticate to DockerHub. These environment variables are loaded to the workflow using `${{ secrets.variable_name }}` syntax, which securely accesses the encrypted variables stored in your repository and use them in your workflows.
Once authenticated, the workflow can push your Docker image artifact to DockerHub. The following steps instruct the workflow to build and push the image:

```yml
- name: Build and push
  uses: docker/build-push-action@v4
  with:
    context: .
    push: true
    tags: ${{ secrets.DOCKERHUB_USERNAME }}/sample_image:latest
```

In the configuration above, GitHub Actions uses the `docker/build-push-action@v4` action to build and push the Docker image. The `context: .` sets the path to the directory that points to your Dockerfile path. It uses the `.`path to point to your current directory to execute your build command. GitHub Actions also sets the `push` flag to `true` to push the image to the DockerHub registry once the build command has successfully built the image. The image will be tagged based on `${{ secrets.DOCKERHUB_USERNAME }}/sample_image:latest`, where `DOCKERHUB_USERNAME` is the repository secrete value you added as your DockerHub username.

### Deployment to Kubernetes Cluster

To create your cluster, you can use managed services such as AWS [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks/) and [AZURE Kubernetes Services (AKS)](https://azure.microsoft.com/en-us/products/kubernetes-service) These services provide tools and features to run Kubernetes clusters. They let you deploy containerized applications to Kubernetes without installing, operating, and maintaining your own [Kubernetes control plane](https://kubernetes.io/docs/concepts/architecture/control-plane-node-communication/). 

Let’s dive in and use AWS EKS to provision a Kubernetes cluster. 

Create a working AWS EKS cluster using your AWS IAM account. You can create the cluster manually or use tools such as [eksctl](https://eksctl.io/). Additionally, Kubernetes applications are deployed to nodes registered with your Amazon EKS cluster. 

While creating the EKS cluster, ensure it has a running [Worker/Group node](https://docs.aws.amazon.com/eks/latest/userguide/create-managed-node-group.html) for running pods or create one [manually](https://ostechnix.com/add-worker-nodes-to-amazon-eks-cluster/). Worker nodes are responsible for running the application containers within the Kubernetes cluster. Without them, no resources will be available to run your cluster [Pods](https://kubernetes.io/docs/concepts/workloads/pods/).

![GitHub Actions and EKS: Setting Up EKS worker nodes](/kubernetes-cluster-pipeline-using-github-actions/eks.png)

#### Setting up Kubectl

To run the cluster using the build machine you created using GitHub action, you will need Kubectl. [Kubectl](https://kubernetes.io/docs/tasks/tools/) run commands against Kubernetes clusters to communicate with [Kubernetes API](https://kubernetes.io/docs/concepts/overview/kubernetes-api/).

Since you are running an Ubuntu machine, you can use the [commands in this guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) to install it. However, you can optionally use many [pre-install kubectl plugins](https://github.com/marcofranssen/setup-kubectl) and get kubectl running on your machine.

You can instruct GitHub action to install Kubectl using the following workflow step by adding the following to the `deploy.yml` file:

```yml
- name: Install kubectl
  uses: azure/setup-kubectl@v2.0
  with:
    version: "v1.25.0"
  id: install
```

This step uses the [azure/setup-kubectl](https://github.com/Azure/setup-kubectl) action to install and set kubectl for interacting with Kubernetes cluster. Note that a kubectl of version `1.25.0` will be installed here. It's always good to specify the version you’re using that matches the version you use to create your EKS cluster. This ensures the kubectl version is compatible with the Kubernetes version running on the EKS cluster and hence to avoid compatibility and unexpected version errors.

![Setting up EKS Kubernetes version](/kubernetes-cluster-pipeline-using-github-actions/version.png)

#### Setting up Cluster Context

Kubernetes uses [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/) to find any information such as [namespace](https://earthly.dev/blog/k8s-namespaces/) and clusters related to the Kubernetes API server of a cluster you are using. This is necessary to authenticate and authorize access to your EKS server when interacting with your cluster.

The cluster context determines the access configuration for your clusters. It defines the parameters needed to access the cluster you want to interact with. Your workflow must switch to the context of your cluster, which has its own set of users and permissions.

By default, the context configuration information lives in `$HOME/.kube/config` directory. To get EKS context for your cluster, run the following command:

```bash
aws eks --region us-west-1 update-kubeconfig --name eks_k8s
```

![GitHub Actions and EKS: Setting up EKS context](/kubernetes-cluster-pipeline-using-github-actions/context.png)

In the context, `us-west-1` should be your AWS cluster region code, and `eks_k8s` should be the name of your EKS cluster.

Navigate to `$HOME/.kube` and check the `config` file containing your cluster's information:

![Kubernetes kubeconfig example](/kubernetes-cluster-pipeline-using-github-actions/config.png)

For GitHub Actions to access your EKS cluster using repository secrets, the context of your config file must be available. However, the config file is multi-line, which GitHub will have trouble interpreting correctly.

To address this, you'll need to convert your config file to base64 encoding, which your workflow can then decode to execute the config context. This will produce the config as a single line that you can add to the GitHub Actions secrets variable.

Use the following command to obtain the base64 encoding for your config file:

Linux:

```bash
cat ~/do-config.yml | base64
```

Windows:

```bash
certutil -encode config.yml output.b64
```

Copy the output and add it as GitHub action secret just like you added `DOCKERHUB_TOKEN` and `DOCKERHUB_USERNAME`. 

Create a new variable, `KUBE_CONFIG`, and add your base64 encode.

The following action will then load the base64 encode and decode it so the workflow can use it:

```yml
- name: Set up EKS kube config
  run: |
    mkdir ${HOME}/.kube | tee -a
    echo "${{ secrets.KUBE_CONFIG }}" | base64 --decode > ${HOME}/.kube/config
    cat ${HOME}/.kube/config
```

Finally, your Cluster should switch to the context using the above config as follows:

```yml
- name: Use kube context
  run: kubectl config use-context arn:aws:eks:us-west-1:1234567890:cluster/eks_k8s
```

Note that `arn:aws:eks:us-west-1:1234567890:cluster/eks_k8s` should reflect your AWS cluster in your config file `context cluster`.

#### Deploying to EKS

You have everything ready to provision your cluster to EKS. Before doing so, ensure your worker nodes/groups are running and ready. Running the following command should return the nodes that are part of your EKS cluster:

```bash
kubectl get nodes
```

![EKS nodes](/kubernetes-cluster-pipeline-using-github-actions/nodes.png)

This confirms that you are ready to run your cluster. GitHub Action will first require AWS authentication to deploy the cluster to EKS as follows:

```yml
- name: AWS Authentication
  uses: aws-actions/configure-aws-credentials@v1
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_ID}}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ID }}
    aws-region: us-west-1
```

In the step above, ensure you create the following GitHub repository secret variable:

- AWS_ACCESS_ID - Your IAM user access key
- AWS_SECRET_ID - Your IAM user secret key

Finally, you can run your `kubectl`, just as you would typically do on your local machine, as follows:

```yml
- name: Run K8s manifest to EKS
  run: kubectl apply -f deployment.yml
```

#### Testing Github Actions Workflow

Once you update your `.github/workflows/deploy.yml` file with above steps ([Check a sample here](https://github.com/Rose-stack/GitHub-Actions-K8s/blob/main/.github/workflows/deploy.yml)), your workflow will be tirgged as follows:

![GitHub Actions and EKS: Workflow triggered](/kubernetes-cluster-pipeline-using-github-actions/one.png)

Accessing your action will display the jobs your are executing:

![The jobs that are executed](/kubernetes-cluster-pipeline-using-github-actions/two.png)
This shows how GitHub Actions is executing one at a time based on how you have outlined them in your `.github/workflows/deploy.yml` file:

![Running GitHub Actions workflow](/kubernetes-cluster-pipeline-using-github-actions/build.png)

Once all steps are executed, GitHub will tell you if the workflow was successful:

![Succesfully deployed workflow](/kubernetes-cluster-pipeline-using-github-actions/final.png)

This means the workflow has provisioned your cluster to EKS, and you can check if it's running by checking its pods by running the following command:

```bash
kubectl get pods
```

![Running EKS cluster pods](/kubernetes-cluster-pipeline-using-github-actions/pods.png)

Or you can inspect your deployed workload on your AES EKS cluster page:

![EKS cluster workload](/kubernetes-cluster-pipeline-using-github-actions/eks-running.png)

Now, with the new found knowledge, why not [Confidently Automate AWS Kubernetes to EKS Cluster Deployment with Terraform](https://guruspedia.com/kubernetes-cluster-pipeline-using-github-actions/) or dive into learning all about [Terraform functions, with examples and best practices to boost your Infrastructure Workflow](https://guruspedia.com/guide-to-terraform-functions/) like a pro.

### Conclusion

CI/CD pipeline deployments create an efficient workflow to automate the deployment processes. DevOps engineers can build, test, and deploy applications to a platform like Kubernetes using CI/CD tools such as GitHub Actions. In this guide, you have learned processes for setting up a Kubernetes cluster using GitHub Actions. You have used a GitHub Actions workflow to create different events and triggers for deploying containers to the Kubernetes cluster hosted on EKS. I hope you found this tutorial helpful.