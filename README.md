# SCA_FINAL_PROJECT

# Deploying a 3 tier application frontend, API, database to Kubernetes cluster  using GCP

I was able  to publish a simple yet functional setup for a dockerized app with Laravel backend and Vue.JS frontend.

## Introduction

To containerize an application refers to the process of adapting an application and its components in order to be able to run it in lightweight environments known as containers.

In this project, i used docker Compose and dockerfile to containerize a Laravel application and vuejs for development. 

# Prerequisites
Ubuntu server
Docker installed on your ubuntu  server,i used  this link https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04 

Docker Compose installed on your server,i used this link https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

# THINGS TO NOTE FIRST
 Create a SQL databse and kubernetes cluster using Terraform ,the github to provision this is infrastructure and the step by step guide
 
      https://github.com/iyanu27/SCA-TASKS/tree/main/Week%209
 
## PHASE 1-Dockerizing the laravel and vuejs application

a. Obtaining the Demo Laravel,Vuejs Application

Lets get started by fetching the demo Laravel application from its Github repository.

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


    
 Refrences:
 
 Installation of Google cloud SDK
 https://www.linuxtechi.com/setup-kubernetes-cluster-google-cloud-platform-gcp/
Installation of Google Kubernetes and deployment yaml
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://scotch.io/tutorials/google-cloud-platform-i-deploy-a-docker-app-to-google-container-engine-with-kubernetes
 
    









