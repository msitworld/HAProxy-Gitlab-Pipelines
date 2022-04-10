This directory contains:

- A `Dockerfile` and a `docker-compose.yml` to build a docker image
- A directory named `config` that are including Nginx configs
- And a `docker-compose.yml` to run and deploy Nginx that forwards external requests to the timestamp node.js app

## Dockerfile
The `Dockerfile` is so simple. It just uses a base image `nginx:alpine` and copies the contents of the directory `config` to the related path.

## Directory `config`
This directory contains some important Nginx config files.

## docker-compose.yml
It creates two containers. One node.js app that listens to port `3000` and prints the current timestamp and Nginx container as a web server that listens to ports `80` on `localhost` and forwards location `/timestamp` to the node.js app. The `proxy_pass` config could be find in `config/conf.d/default.conf`. All Nginx config files are used as Docker Volume. It's obvious that to forward HTTPS requests, we should bind port `443` as well and config SSL certificates for Nginx. Note that you could uncomment the commented lines and change the Nginx config file in the directory `config` and then validate your changes using `docker exec -it nginx nginx -t` and subsequently reload nginx based on new changes by `docker exec -it nginx nginx -s reload`.