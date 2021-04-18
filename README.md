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

      sudo cp .env.example .env,open with nano .env

     APP_NAME=laravel-vue-spa
    APP_ENV=dev
    APP_KEY=
    APP_DEBUG=true
    APP_URL=34.67.89.10

    LOG_CHANNEL=stack

    DB_CONNECTION=mysql
    DB_HOST=db
    DB_PORT=3306
    DB_DATABASE=iyanudb
    DB_USERNAME=Iyanu
    DB_PASSWORD=iyanu

# Step 3 — Setting Up the Application’s Dockerfile
 #I created a new Dockerfile with the following configuration as shown below and named it "Dockerfile.prod"
     #Client App
FROM node:14.15.0 as vuejs
LABEL authors="Iyanu"
RUN mkdir -p /app/public
COPY package.json webpack.mix.js package-lock.json /app/
COPY resources/ /app/resources/
WORKDIR /app
RUN npm install && npm run prod

#Server Dependencies
FROM composer:2.0.8 as vendor
WORKDIR /app
COPY database/ database/
COPY composer.json composer.json
COPY composer.lock composer.lock
RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist

#Final Image
FROM php:7.4-apache as base
#install php dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libonig-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    libzip-dev \
    zip \
    jpegoptim optipng pngquant gifsicle \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl

# change the document root to /var/www/html/public
RUN sed -i -e "s/html/html\/public/g" \
    /etc/apache2/sites-enabled/000-default.conf

# enable apache mod_rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . /var/www/html
COPY --from=vendor /app/vendor/ /var/www/html/vendor/
COPY --from=vuejs /app/public/js/ /var/www/html/public/js/
COPY --from=vuejs /app/public/css/ /var/www/html/public/css/
COPY --from=vuejs /app/mix-manifest.json /var/www/html/mix-manifest.json

RUN pwd && ls -la

RUN php artisan key:generate --ansi && php artisan storage:link && php artisan config:cache && php artisan route:cache


# these directories need to be writable by Apache
RUN chown -R www-data:www-data /var/www/html/storage \
    /var/www/html/bootstrap/cache

# copy env file for our Docker image
# COPY env.docker /var/www/html/.env

# create sqlite db structure
RUN mkdir -p storage/app \
    && touch storage/app/db.sqlite

VOLUME ["/var/www/html/storage", "/var/www/html/bootstrap/cache"]

EXPOSE 80
 
# Step 4 — Creating a Multi-Container Environment with Docker Compose named it "docker-compose production.yml
     version: "3.8"
services:
  server:
    build:
      context: .
      dockerfile: Dockerfile.prod
      target: base
    container_name: server
    env_file:
      - ./.env
    depends_on:
      - mysql
    links:
      - mysql
    ports:
      - 80:80
    networks:
      - back-tier
  mysql:
    image: mysql
    container_name: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_DATABASE: iyanudb
      MYSQL_USER: iyanu
      MYSQL_ROOT_PASSWORD: iyanu
    ports:
      - 3306:3306
    volumes:
      - ./mysql/init.sql:/data/application/init.sql
      - mysql_data:/var/lib/mysql
    networks:
      - back-tier

volumes:
  mysql_data:
networks:
  back-tier:

# step 5-I run the application in production mode simply run docker-compose -f docker-compose.production.yml up -d to up the service.


## PHASE 2- PUSH THE BUILT IMAGE TO DOCKER HUB REPOSITORY
 The image registry i will be using is Docker Hub. First, your account has to be created, then create a repository with any name, i 
 named it laravelvuejsapplication. Now, let see the steps i followed: 



