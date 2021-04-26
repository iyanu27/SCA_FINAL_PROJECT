# SCA_FINAL_PROJECT

This repository contains the Terraform(db.tf,main.tf,gke.tf),Kubernetes(deployment.yaml and service.yaml) ,Docker(dockercompose and dockerfile).

# Deploying a 3 tier application frontend, API, database to Kubernetes cluster  using GCP

I was able  to publish a simple yet functional setup for a dockerized app with Laravel backend and Vue.JS frontend.

## Introduction

To containerize an application refers to the process of adapting an application and its components in order to be able to run it in lightweight environments known as containers.

In this project, i used docker Compose and dockerfile to containerize a Laravel application and vuejs for development. 

## PHASE 1- Create a SQL database and kubernetes cluster using Terraform 

# Automating a GCP SQL Database in a Private Subnet with Terraform

## Requirements
1. Google Cloud Platform(GCP) Project
2. GCP service account private key
3. Google Compute Engine
4. Terraform (for automating resource creation)

### Terraform Installation
1. Copy link address for [Terraform](https://www.terraform.io/downloads.html) download
  ```
    $ wget https://releases.hashicorp.com/terraform/0.12.16/terraform_0.12.16_darwin_amd64.zip
    $ unzip terraform_0.12.16_darwin_amd64.zip
    $ mv terraform Downloads/
    $ vim ~/.profile
    Add `export PATH="$PATH:~/Downloads"` to ~/.profile
  ```
2. Verify installation: `$ terraform` or `$ terraform --version`
3. `$ mkdir -p ~/terraform/vpc`

### Google Cloud Platform
1. [Create project](https://console.cloud.google.com/projectcreate) from GCP console
2. From the GCP main menu ☰ > Enable the Compute Engine API
3. Navigate to Credentials from the left panel and select **Create Credentials** > choose **Service account key** from the dropdown > **New service account**:
      + Choose a name and set role to **Editor**
      + **JSON** > **Create**
      + Now the private key will download to your local machine.
4. [Install](https://cloud.google.com/sdk/docs/downloads-interactive) the [gcloud CLI](https://cloud.google.com/sdk/gcloud/). For Linux/Mac:

  ```
    $ curl https://sdk.cloud.google.com | bash
    $ exec -l $SHELL
    $ gcloud init
  ```
5. From `~/terraform/vpc`, create a Terraform config file, `main.tf`, with the following configuration:

      + **Note:** You will need to edit the values of the following argument names (credentials, project)

  ```
    provider "google" {
      credentials = file("<FILE_PATH>.json")         

      project = "<PROJECT_ID>"              
      region  = "us-west1"
      zone    = "us-west1-a"
    }
/This is for creation of vpc/
   resource "google_compute_network" "vpc" {
  name                    = "master-default-gw"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = true
}

resource "google_compute_global_address" "private_ip_block" {
  name         = "private-ip-block"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = google_compute_network.vpc.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network       = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}
  ```
6. To create the  SQL database with Terraform in a Private subnet copy the "db.tf" file

7. `$ terraform init`
    + You should now see `Terraform has been successfully initialized!`
8. `$ terraform apply` and enter 'yes' to continue.
    + You should now see `Apply complete! Resources: 2 added, 0 changed, 0 destroyed.`
  ![image](https://user-images.githubusercontent.com/57386428/113719657-b629e780-96a2-11eb-852a-6a9266f11e2c.png)
    + From the GCP console you can see your newly created SQL instance, substituting <PROJECT_ID>: 
    `https://console.cloud.google.com/compute/instances?project=<PROJECT_ID>` 
    
9.To test if i can connect to the db i made sure the SQL databse and the VM accessing it  is on the same network default
![image](https://user-images.githubusercontent.com/57386428/115313560-5adb0900-a128-11eb-934c-832ec3f2c874.png)

![image](https://user-images.githubusercontent.com/57386428/115313650-83fb9980-a128-11eb-9afc-bcc58a32558f.png)

10.To connect to my db,I used the command  mysql --host=172.16.224.3   --user=Iyanu --password

![image](https://user-images.githubusercontent.com/57386428/115313438-1e0f1200-a128-11eb-8065-83ea28d26494.png)

![image](https://user-images.githubusercontent.com/57386428/115313970-2025a080-a129-11eb-99d7-3f167c3f63c6.png)

# To deploy Google kubernetes cluster on GCP
1. To provision the Kubernetes cluster i created the gke.tf 
 
    terraform init`
    
2. After that go to connect and paste the following on cloud shell
![image](https://user-images.githubusercontent.com/57386428/115622468-bf26d580-a2ac-11eb-822f-1799674972ab.png)
  
  gcloud container clusters get-credentials sca-cluster --zone us-west1-a --project keen-clarity-309414
3. Then install kubectl
    sudo apt-get install kubectl
    
4. Then run the following to get the node
      kubectl get node
   ![image](https://user-images.githubusercontent.com/57386428/115622720-12008d00-a2ad-11eb-96be-b5b94deda5cd.png)

  
  
  =====================
## PHASE 2-Dockerizing the laravel and vuejs application

# Prerequisites
 Ubuntu server
 Docker installed on your ubuntu  server,i used  this link 
   https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04 

Docker Compose installed on your server,i used this link 
   https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

a. Obtaining the Demo Laravel,Vuejs Application

First, i cloned the demo Laravel application from its Github repository.

         https://github.com/cretueusebiu/laravel-vue-spa

b.Setting Up the Application’s .env File
  The Laravel configuration files are located in a directory called config, inside the application’s root directory. Additionally, a .env file is used to set up environment-dependent configuration, such as credentials and any information that might vary between deploys. 

 I created a new .env file to customize the configuration options for the development environment we’re setting up. Laravel comes with  an example.env file that we can copy to create our own:

c.  Setting Up the Application’s Dockerfile
 
I created a new Dockerfile with the following configuration and named it "Dockerfile.prod",attached in the this repository
![image](https://user-images.githubusercontent.com/57386428/115456927-99300100-a1d8-11eb-8f77-8fdd8aba3d5a.png)
     
d. Creating a Multi-Container Environment with Docker Compose 

I created a new docker-compose attached in this repository and named it "docker-compose-production.yml" 

![image](https://user-images.githubusercontent.com/57386428/115457025-be247400-a1d8-11eb-8909-1dc7fdbbe28d.png)

e. I run the application in production mode 

simply run docker-compose -f docker-compose.production.yml up -d to up the service.

![image](https://user-images.githubusercontent.com/57386428/115457099-ddbb9c80-a1d8-11eb-8256-130dd261f4d4.png)
![image](https://user-images.githubusercontent.com/57386428/115933442-bb798700-a443-11eb-8239-d89eea8ce408.png)


simply run docker-compose -f docker-compose.production.yml down  to stop the service.

## PHASE 2- PUSH THE BUILT IMAGE TO DOCKER HUB REPOSITORY

 a. The image registry i will be using is Docker Hub. First, your account has to be created, then create a repository with any name, i 
 named it laravelvuejsapplication. Now, let see the steps i followed: 
  
![image](https://user-images.githubusercontent.com/57386428/115301887-a5ec2080-a116-11eb-8dbc-18d479fd8fe1.png)

b.To push the built image to docker hub repository,i ran the command docker ps to get the container id of the image
![image](https://user-images.githubusercontent.com/57386428/115302041-d469fb80-a116-11eb-8cfd-07c75c51cdff.png)

c. Then, “sudo docker commit 1d96f9d249ac iyanu27/laravelvuejsapplication” to commit the images  and “sudo docker push iyanu27/laravelvuejsapplication” to push the application to my laravelvuejs repository 

![image](https://user-images.githubusercontent.com/57386428/115302140-f3688d80-a116-11eb-8ea8-79c03627e170.png)

d. After the application has been pushed to docker hub repository,lets verify the status on docker hub

![image](https://user-images.githubusercontent.com/57386428/115302233-12ffb600-a117-11eb-8900-44d97d76d245.png)


## PHASE 3:  Define YAML File To Create A Deployment In Kubernetes Cluster

a. I created a Kubernetes cluster with terraform,i will be deploying the dockerized image to the container,kubernetes cluster shown below:

![image](https://user-images.githubusercontent.com/57386428/115378625-9657f080-a185-11eb-8edd-f9c58def477e.png)

b. Create a file named it deployment.yml that consist the following configuration
       
![image](https://user-images.githubusercontent.com/57386428/115378770-bf788100-a185-11eb-8f69-185a2450eacf.png)

    Note: i made sure the image is the name of the dockerized image being pushed to docker hub
    
c.  I connected to my Google kubernetes cluster on GCP using cloud shell and by clicking connect
  
  ![image](https://user-images.githubusercontent.com/57386428/115423351-97ebdd80-a1b2-11eb-9f1a-046128ae6a55.png)
  
d.Added a deployment.yaml and service.yaml file as shown below to create the deployment
  ![image](https://user-images.githubusercontent.com/57386428/115453730-cf6b8180-a1d4-11eb-9091-2b2d75c34543.png)
 
 ![image](https://user-images.githubusercontent.com/57386428/115464130-7524ed80-a1e1-11eb-98ba-7f34fd3aa29d.png)
   
e. To create the deployment, i used the command 
    
    kubectl create -f deployment.yml
    
![image](https://user-images.githubusercontent.com/57386428/115453313-59671a80-a1d4-11eb-860f-3abf431fc053.png)

 f.I was able to view the deployment and the created pods by running kubectl get deployments and kubectl get pods
 
 ![image](https://user-images.githubusercontent.com/57386428/115454153-4dc82380-a1d5-11eb-87c0-48a268dc6942.png)
 
 g. The Kubernetes master creates the load balancer and related Compute Engine forwarding rules, target pools, and firewall rules to make the service fully accessible from outside of Google Cloud Platform.To create the service run 
     kubectl create -f service.yml

![image](https://user-images.githubusercontent.com/57386428/115455216-83b9d780-a1d6-11eb-8b4d-679e83a45717.png)

h. Once the service is created, i can get the externally accessible IP address by listing all the services (kubectl get services). The external IP may take a few seconds to be visible.I got this.
 

![image](https://user-images.githubusercontent.com/57386428/115464228-9f76ab00-a1e1-11eb-8cf7-d4a09bb91fe3.png)

![image](https://user-images.githubusercontent.com/57386428/115456057-9680dc00-a1d7-11eb-90c9-0d7d83672a8e.png)

![image](https://user-images.githubusercontent.com/57386428/115464405-e369b000-a1e1-11eb-8cf9-7f4a1b070173.png)

i.To access the kubernetes,i accessed it with the externalIpaddress:80


![image](https://user-images.githubusercontent.com/57386428/115466099-71469a80-a1e4-11eb-8f01-848ee7162cb6.png)
![image](https://user-images.githubusercontent.com/57386428/116005715-15518c80-a5bd-11eb-928a-d952f7ecdfb1.png)
![image](https://user-images.githubusercontent.com/57386428/116005766-403be080-a5bd-11eb-91cc-d34e8c3788ad.png)

# PHASE 4- setup CI/CD to deploy application to kubernetes,i used Jenkins

 a.Installed Jenkins on my VM
 ![image](https://user-images.githubusercontent.com/57386428/116007376-6749e080-a5c4-11eb-8964-be3d41bb602a.png)
![image](https://user-images.githubusercontent.com/57386428/116007518-f9ea7f80-a5c4-11eb-8ee2-a9c8ab35038c.png)

b.Forked the laravel repository
https://github.com/iyanu27/laravel-vue-spa.git

c. To deploy the application to kubernetes with Jenkins,I installed Google Kubernetes plugin on Jenkins

![image](https://user-images.githubusercontent.com/57386428/116069154-edefd380-a63f-11eb-8250-bdabe6fa51c4.png)


d.I Configured Jenkins User to Connect to the Google Kubernetes Cluster ,used this command;

    $ sudo visudo -f /etc/sudoers
    Then added jenkins ALL= NOPASSWD: ALL
![image](https://user-images.githubusercontent.com/57386428/116067190-c7309d80-a63d-11eb-88de-f591609093cf.png)

This will also allow the Jenkins User to run su (super user) commands without the need to input a password. Once this is done, i switch ed to the Jenkins user on the terminal.

![image](https://user-images.githubusercontent.com/57386428/116067497-07901b80-a63e-11eb-8f1f-817ad5863798.png)

e. Setup GCP and Docker Credentials on Jenkins

I created a service account on GCP  enable the APIs needed by the Jenkins GKE plugin such as the 

Compute Engine API

Kubernetes Engine API

Service Management API

Cloud Resource Manager API



I Login with the user that I created. On the left sidebar, click on ‘Manage Jenkins’. This opens the Management dashboard of Jenkins. Click on ‘Manage Credentials’.

For dockerhub credientials

![image](https://user-images.githubusercontent.com/57386428/116071395-b6365b00-a642-11eb-8686-e8c99e5f6630.png)

For GCP credientials

![image](https://user-images.githubusercontent.com/57386428/116071624-f695d900-a642-11eb-9213-ffbb3d5b8f5c.png)

![image](https://user-images.githubusercontent.com/57386428/116071692-0a413f80-a643-11eb-807a-0a8301825da3.png)
   
f. Create and enabled a GitHub repository webhook

Log in to GitHub repository. Note the HTTPS URL to the repository.

Repository URL

Click the "Settings" tab at the top of the repository page.

Select the "Webhooks" sub-menu item. Click "Add webhook".

In the "Payload URL" field, enter the URL http://35.238.27.123:8080

![image](https://user-images.githubusercontent.com/57386428/116070852-f47f4a80-a641-11eb-81b3-1f6ccd556046.png)

g. Create the Jenkins pipeline project for deployment into kubernetes 
  Log in to Jenkins (if you're not already logged in).
 Click "New item". called the project laravel-vuejs set the project type to "Pipeline". Click "OK" to proceed.
 
![image](https://user-images.githubusercontent.com/57386428/116071905-496f9080-a643-11eb-813a-d0f7cd2e7839.png)
    
Under  "General" tab on the project configuration page i checked the "GitHub project" checkbox. Enter the complete URL to your GitHub project.

 Checked the github hook trigger for GITscm pooling
  
![image](https://user-images.githubusercontent.com/57386428/116072251-b420cc00-a643-11eb-90a4-4c34d7178d33.png)

![image](https://user-images.githubusercontent.com/57386428/116072395-dfa3b680-a643-11eb-8df4-7f2beeaecdad.png)

 Under the Pipeline tab,i  added the GCP credentials and the docker hub and added the pipeline script as follows:
 pipeline {
    agent any
    environment {
        PROJECT_ID = 'keen-clarity-309414'
        CLUSTER_NAME = 'sca-cluster'
        LOCATION = 'us-west2'
        CREDENTIALS_ID = 'gke'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    myapp = docker.build("iyanu27/laravel-vuejs:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            }
        }
    }    
}
               pipeline {
    agent any
    environment {
        PROJECT_ID = 'keen-clarity-309414'
        CLUSTER_NAME = 'sca-cluster'
        LOCATION = 'us-west2'
        CREDENTIALS_ID = 'gke'
    }
    stages {
        stage("Checkout code") {
            steps {
                checkout scm
            }
        }
        stage("Build image") {
            steps {
                script {
                    myapp = docker.build("DOCKER-HUB-USERNAME/hello:${env.BUILD_ID}")
                }
            }
        }
        stage("Push image") {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
                            myapp.push("latest")
                            myapp.push("${env.BUILD_ID}")
                    }
                }
            }
        }        
        stage('Deploy to GKE') {
            steps{
                sh "sed -i 's/hello:latest/hello:${env.BUILD_ID}/g' deployment.yaml"
                step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
            }
        }
    }    
}


 Refrences:
 
 Installation of Google cloud SDK
 https://www.linuxtechi.com/setup-kubernetes-cluster-google-cloud-platform-gcp/
Installation of Google Kubernetes and deployment yaml
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://scotch.io/tutorials/google-cloud-platform-i-deploy-a-docker-app-to-google-container-engine-with-kubernetes
https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04
 
    









