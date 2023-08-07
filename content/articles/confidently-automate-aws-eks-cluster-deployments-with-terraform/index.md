---
layout: blog
status: publish
published: true
url: /confidently-automate-aws-eks-cluster-deployments-with-terraform/
title: Confidently Automate AWS EKS Cluster Deployment with Terraform
description: Deploy you AWS EKS Cluster using Terraform automatically. Dive into the steps of automating deployment to the EKS cluster with Terraform.
date: 2023-07-26T03:28:29-04:00
topics: [DevOps]
pick: [top]
excerpt_separator: <!--more-->
images:

  - url: /confidently-automate-aws-eks-cluster-deployments-with-terraform/hero.png
    alt: Confidently Automate AWS EKS Cluster Deployments with Terraform
---

AWS EKS is a fully managed Kubernetes service for AWS that simplifies the deployment, scaling, and management of containerized applications using Kubernetes. This guide demonstrates how to deploy the AWS EKS cluster using Terraform automatically.
<!--more-->

[Terraform](https://www.terraform.io/) creates and manages infrastructure provisioning using code. As an IaC tool, it creates automated deployment and configuration to cloud resources. This creates a way of provisioning and managing cloud infrastructure from cloud providers such as AWS, Azure, and GCP. Let’s dive and go through the steps of automating deployment to the EKS cluster using Terraform. 

### Prerequisites

To proceed in this article, it is helpful to have the following:

- An [IAM AWS user account](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) with sufficient permissions to create and manage EKS resources. For easier understanding, you can give your IAM user administrator permissions in this case.
- The [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html) installed and configured on your local computer.
- [Terraform](https://developer.hashicorp.com/terraform/downloads) installed on your machine.

> Related: [Guide to Terraform Functions for Infrastructure Automation - With Examples and Best Practices](https://guruspedia.com/guide-to-terraform-functions/)

- A basic understanding of how to use [Kubernetes](https://kubernetes.io/docs/concepts/overview/components/) and its components with [Kubectl](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html) installed.
- [Docker](https://www.docker.com/) installed on your computer.
- A demo application ready with a working Dockerfile for packaging and creating the application Docker image.

> Related: [Creating Dockerfile: Tips to slim Docker images using Dockerfiles](https://guruspedia.com/how-to-minimize-docker-mages/)

- Ensure you have [Git](https://git-scm.com/downloads) installed and added to PATH.
- A [DockerHub](https://hub.docker.com/) account.

### Setting up Application Docker Image

A Kubernetes cluster runs on a Docker image that packages your application code and dependencies. In Docker, a Dockerfile defines the instructions for building your application image. In this example, I will use this [demo Node.js application](https://github.com/Rose-stack/Terraform-with-AWS-EKS). It has an equivalent Dockerfile, and all the configurations need to build a Docker image as follows:

```dockerfile
# Pull node image
FROM node:20-alpine 
# define the working directory.
WORKDIR /usr/src/app 
# copy package.json file.
COPY package.json . 
# install the dependencies
RUN npm install 
# copy the other files.
COPY . . 
# expose a port to run on
EXPOSE 4000 
# start the application
CMD ["node","app.js"] 
```

AWS EKS is a cloud service accessed remotely. This means it can’t pull the Docker image locally. You must push the image remotely, where the EKS cluster will look up and pull the image to create your Kubernetes cluster. Let’s create the application image and push it to [DockerHub](https://hub.docker.com/), a free-to-use registry to host your Docker images remotely.

First, build a Docker image locally by running the following command, ensuring `your_dockerhub_username` reflects your DockerHub username:

```bash
docker build -t your_dockerhub_username/simple_express_app .
```

Run the image to test that the packed application is working as expected:

```bash
docker run -d -p 8000:4000 --name your_dockerhub_username/simple_express_app simple_express_app
```

The above command will run the image in the background `(-d)`, exposing port 8000, which will connect to the locally exposed 4000, and the container's name is `simple_express_app`. The application should now run locally on port 8000 and can be accessed on your browser using the URL `http://localhost:8000`:

![Confidently Automate AWS EKS Cluster Deployments with Terraform](/confidently-automate-aws-eks-cluster-deployments-with-terraform/simple-express-app.png)

Now that you can run the image, let's push it to DockerHub in a few steps. From your terminal, login to DockerHub:

```bash
docker login
```

You will be required to provide your DockerHub username and password here. After logging in, push the image to DockerHub:

```bash
docker push your_dockerhub_username/simple_express_app
```

In this case, you will use `your_dockerhub_username/simple_express_app` in the coming stage to let the EKS Kubernetes cluster know where your application image is located.

### Configuring AWS

Terraform will provision your infrastructure to AWS. Thus, you need Terraform to execute your AWS credentials and provision your deployment on EKS.

Terraform uses [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to authenticate and interact with any resources AWS supports. To connect AWS with Terraform, you will need to create a session using your terminal that will export the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` that you used to configure your AWS IAM use. AWS CLI will export these keys using the following commands:

```bash
export AWS_ACCESS_KEY_ID=your_aws_access_key_id

export AWS_SECRET_ACCESS_KEY=your_aws_secret_access_key
```

AWS will now be able to authenticate Terraform. To do Terraform will use the [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) to access your EKS resources. Create a `main.tf` file containing the following instructions for creating a provider:

```terraform
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "your_aws_iam_region_code"
  access_key = "your_aws_access_key_id"
  secret_key = "your_aws_secret_access_key"
}
```

From above, Terraform will configure an AWS provider, specifying the region and credentials to authenticate access to AWS resources. 

For Terraform code to work, initialize the Terraform directory containing your `main.tf`. This initializes your Terraform working directory and prepares it by downloading the required provider plugins and modules. Terraform uses `terraform init` command to do so. Go ahead and run the following command:

```bash
terraform init
```

The above command will install the AWS provider and set you up to start running Terraform code. If successfully **Terraform has been successfully initialized,** will be shown as follows:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform init command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/terraform-init-command.png)

### Setting up the AWS EKS Cluster IAM role 

Using AWS EKS UI, you can create your cluster manually. However, in this case, let’s see how we can write code to create the EKS cluster on AWS without manually creating it.

#### AWS EKS Cluster IAM role

First, you need code that creates an IAM role for the AWS Kubernetes service. In this example, you will provision an EKS addon to allow the Kubernetes cluster to use the EKS [EBSCSI driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html). Define `data` to hold the policy permissions as follows:

```terraform
# main.tf
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
```

Terraform will use `ebs_csi_policy` to retrieve the ARN of the IAM policy for the EBS CSI driver. To use the `ebs_csi_policy` policy, create an IAM role to be assumed by your EKS EBS CSI driver. In this case, define the roles and policy on using [irsa-ebs-csi module](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest) as follows:

```terraform
# main.tf
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}
```

The `irsa-ebs-csi` module creates IAM resources using [AWS OIDC provider](https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest). It uses the following parameters:

- `create_role` for creating the IMA role.
- `role_name` to specify the name of the role to create.
- `provider_url` that points to the OIDC provider.
- `role_policy_arns` with the ARNs, the IAM policies attached to the role.

EBS CSI driver addon creates the roles and policies the EKS cluster needs and should be provisioned to create your EKS cluster resources as follows: 

```terraform
# main.tf
resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.5.2-eksbuild.1"
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}
```

#### Creating a VPC

[VPC (Virtual Private Cloud)](https://earthly.dev/blog/aws-networks/#vpcs) creates an isolated network within the AWS  to launch your AWS resources, such as EKS, on your own private network. This gives you control over resources such as [IP address and subnets](https://earthly.dev/blog/aws-networks/#subnets) to launch your cluster into and securely expose the cluster to your AWS [availability zones](https://earthly.dev/blog/aws-networks/#regions-and-availability-zones). 

To create a VPC, first, define `data` to hold your availability zones:

```terraform
# main.tf
data "aws_availability_zones" "available" {}
```

Define the cluster's name under the `locals` object follows. Feel free to change the prefix to your desired name:

```terraform
# main.tf
locals {
  cluster_name = "simple_express_app-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 9
  special = false
}
```

This generates a unique name AWS will use to create your VPC subnets. `locals` creates and holds values you need multiple times throughout a configuration instead of manually adding such values each time you require them. You can go ahead and create your VPC module as follows:

```terraform
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "simpleexpressapp-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = ["10.0.1.0/24", "10.0.7.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}
```

From above, the private and public subnets should be configured to have at least two availability zones. Multiple availability zones provide high availability and fault tolerance to the resources you provision to AWS. Here `azs  = slice(data.aws_availability_zones.available.names, 0, 2)` tells VPC to select the first two available availability zones in your current region you created earlier using `region  = "your_aws_iam_region_id"`.

#### Creating AWS EKS Cluster Worker Nodes

[Worker Nodes](https://kubernetes.io/docs/concepts/overview/components/#node-components) runs your application workloads. Worker nodes run within your Kubernetes cluster. For Kubernetes pods to run your workload, it executes containers into Pods that then run on [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/). Node provides virtual runtime for Kubernetes, and your EKS cluster must have a running node that Kubernetes will use to run your workload.

Using Terraform create your EKS [Node groups](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to run your infrastructure. The following Terraform code launches [EKS managed Node group](https://docs.aws.amazon.com/eks/latest/userguide/create-managed-node-group.html) and register them within your EKS cluster:

```terraform
# main.tf
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node_group_1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }

    two = {
      name = "node_group_2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
```

Terraform will access your `cluster_name` and use VPC to launch your node groups. In this case, `eks_managed_node_groups` will use default settings to create two managed node groups running on `t3.small` instance types. Once the nodes join the cluster, you can deploy Kubernetes applications to them.

#### Deploy EKS Cluster

Now that you have the resources needed to create the cluster let’s check how Terraform will create the above example resources. First, run the following command to initialize Terraform directory to ensure all providers are ready:

```bash
terraform init
```

To add your resources to AWS, run Terraform apply command:

```bash
terraform apply
```

This should successfully create your resources as follows:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform apply command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/terraform-apply-command.png)

You can verify these resources in your AWS account. For example, the cluster name will be created as follows:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: A Terraform provisoned EKS cluster](/confidently-automate-aws-eks-cluster-deployments-with-terraform/eks-cluster.png)

This cluster will be created with the Worker Nodes as you instructed Terraform to. Navigate to the cluster compute tab and confirm your node groups have been created:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform provisoned EKS node groups](/confidently-automate-aws-eks-cluster-deployments-with-terraform/node-groups.png)

You also check the same using `kubectl get nodes` as follows:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform provisoned EKS node groups](/confidently-automate-aws-eks-cluster-deployments-with-terraform/get-nodes.png)

Everything has worked as expected. You now have a ready EKS cluster; let's now deploy the application to it. 

### Setting up Kubernetes Context and Namespace

[Kubernetes context](https://loft.sh/blog/kubectl-get-context-its-uses-and-how-to-get-started/) creates the access parameters to connect to a Kubernetes cluster. These include your cluster name and [namespace](https://earthly.dev/blog/k8s-namespaces/). These details are created using a config file. First, generate one to establish a connection to the cluster contest using your terminal as follows:

```bash
aws eks --region us-west-1 update-kubeconfig --name simple_express_app-nwynSUN0N
```

Note that `us-west-1` should be your region code, and simple_express_app-nwynSUN0N is the EKS cluster name you just created above.

To use the same context, generate context and create the namespace using Terraform as follows:

```terraform
# main.tf
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "simple-express-app" {
  metadata {
    name = "simple-express-app"
  }
}
```

Terraform will automatically instruct AWS to generate a `config` file and save it in the `~/.kube/config` of the machine running your EKS cluster and add a namespace ` simple-express-app` to organize your resources within the cluster.

### Deploying EKS Deployment Manifest

To run your cluster, Kubernetes uses a deployment resource. Kubernetes deployment resource is equivalent to the [manifest yaml](https://kubernetes.io/docs/concepts/cluster-administration/manage-deployment/) file you write describing how to deploy your cluster. It contains [Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/) such as replicas, metadata, spec, container, etc.

Instead of creating these properties manually in a `.yaml` file format, you can use Terraform to create your deployment as follows:

```terraform
# main.tf
resource "kubernetes_deployment" "simple-express-app" {
  metadata {
    name      = "simple-express-app"
    namespace = kubernetes_namespace.simple-express-app.metadata.0.name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "simple-express-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "simple-express-app"
        }
      }
      spec {
        container {
          image = "your_docker_username/simple_express_app"
          name  = "simple-express-app-container"
          port {
            container_port = 4000
          }
        }
      }
    }
  }
}
```

Terraform will create the Kubernetes Deployment resource `simple-express-app` with two replicas. To your application, Kubernetes API will execute the image you previously deployed to DockerHub using `spec.container`. In this case, `image` must be the name of your DockerHub image. Ensure you rename `your_docker_username/simple_express_app` accordingly.

### Deploying EKS Kubernetes service

Likewise, to expose your deployed application [services such as Load Balancer](https://kubernetes.io/docs/concepts/services-networking/service/) to expose an application running in your cluster. Go ahead and use Terraform to create a Kubernetes service as follows:

```terraform
# main.tf
resource "kubernetes_service" "simple-express-app" {
  metadata {
    name      = "simple-express-app"
    namespace = kubernetes_namespace.simple-express-app.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.simple-express-app.spec.0.template.0.metadata.0.labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 4000
    }
  }
}
```

The `simple-express-app` resource will be created, and it runs `kubernetes_deployment.simple-express-app` created by the deployment manifest. This will expose the application using a `LoadBalancer`; this way, the service will listen to port 80 and port 4000 as the target port the application is listening to.

### Provisioning to EKS Cluster

Up to this point, you have everything you need to provision Terraform to EKS using Terraform. Let’s dive in and now allow Terraform to deploy the infrastructure to AWS. First, ensure you initialize terraform directory to ensure all providers are ready:

```bash
terraform init
```

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform Init Command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/init-command.png)

Next, run a [Terraform plan command](https://developer.hashicorp.com/terraform/cli/commands/plan) to preview all changes Terraform plans to add to your infrastructure:

```bash
terraform plan
```

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform Plan Command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/terraform-plan.png)

Finally, you can now deploy to EKS using [Terraform apply command](https://developer.hashicorp.com/terraform/cli/commands/apply) :

```bash
terraform apply
```

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform Apply Command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/apply-command.png)

In the adjacent prompt to deploy, enter **yes**.

![Terraform Apply Command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/terraform-apply-command-yes.png)

Once the deployment is done, run the below command to check the running services:

```bash
kubectl gets services -A
```

![Confidently Automate AWS EKS Cluster Deployments with Terraform: EKS service](/confidently-automate-aws-eks-cluster-deployments-with-terraform/eks-service.png)

From the results, select the **External IP** and paste it into your browser. You should be able to interact with your deployed application as follows:

![Confidently Automate AWS EKS Cluster Deployments with Terraform: EKS provisioned demo app](/confidently-automate-aws-eks-cluster-deployments-with-terraform/provisioned-demo-app.png)

Once the testing is done, to avoid incurring extra charges, run the below command to destroy the cluster resources:

```bash
terraform destroy
```

![Confidently Automate AWS EKS Cluster Deployments with Terraform: Terraform Destroy Command](/confidently-automate-aws-eks-cluster-deployments-with-terraform/destroy-command.png)

Now, with the new found knowledge, why not [Automate and Deploy Kubernetes CICD pipeline using GitHub Actions and EKS](https://guruspedia.com/kubernetes-cluster-pipeline-using-github-actions/) or dive into learning all about [Terraform functions, with examples and best practices to boost your Infrastructure Workflow](https://guruspedia.com/guide-to-terraform-functions/) like a pro.

### Conclusion

Using Terraform provides a streamlined workflow for managing infrastructure as code. This guide used Terraform to simplify deploying an EKS cluster and abstract the complexity of deploying AWS infrastructure and Kubernetes resources. You learned how to use Terraform to automate the deployment of an Amazon EKS cluster. The guide created Terraform code for creating the EKS cluster, its worker nodes, and Kubernetes resources such as namespaces, deployments, and services.
