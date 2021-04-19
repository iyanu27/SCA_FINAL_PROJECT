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

# Step 1 — Obtaining the Demo Laravel,Vuejs Application

Lets get started by fetching the demo Laravel application from its Github repository.

         https://github.com/cretueusebiu/laravel-vue-spa

# Step 2 — Setting Up the Application’s .env File
  The Laravel configuration files are located in a directory called config, inside the application’s root directory. Additionally, a .env file is used to set up environment-dependent configuration, such as credentials and any information that might vary between deploys. 

 I created a new .env file to customize the configuration options for the development environment we’re setting up. Laravel comes with  an example.env file that we can copy to create our own:

# Step 3 — Setting Up the Application’s Dockerfile
 
I created a new Dockerfile with the following configuration and named it "Dockerfile.prod"
     
# Step 4 — Creating a Multi-Container Environment with Docker Compose 

I created a new docker-compose attached in this repository and named it "docker-compose-production.yml" 

# step 5-I run the application in production mode 

simply run docker-compose -f docker-compose.production.yml up -d to up the service.

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

## PHASE 3: How to push the dockerized image to kubernetes
a.  I Installed minikube  use this link minikube start | minikube (k8s.io)

![image](https://user-images.githubusercontent.com/57386428/115302393-3e82a080-a117-11eb-8ccc-bbdd37258918.png)


![image](https://user-images.githubusercontent.com/57386428/115302486-55c18e00-a117-11eb-8274-cb2314eddad3.png)

## PHASE 4:  Define YAML File To Create A Deployment In Kubernetes Cluster









