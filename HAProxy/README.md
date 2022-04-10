This directory contains these files:

## haproxy.cfg
HAProxy config file

## Dockerfile
To build an HAProxy docker image based on the `haproxy.cfg`. Build it using `docker build -t haproxy-snapp:latest .`

## docker-compose.yml
This docker-compose run 4 docker containers:

- One container named `haproxy` that uses `haproxy.cfg`
- A node.js app named `hello-snappmarket` as `default_backend`
- Two node.js apps named `timestamp1` and `timestamp2` for load balancing the requests on them

You could uncomment the commented line and change the `haproxy.cfg` and then validate your changes by `docker exec -it haproxy haproxy -f /usr/local/etc/haproxy/haproxy.cfg -c`, and finally run `docker kill -s HUP haproxy` to reload haproxy based on new changes.


## .gitlab-ci.yml
It's a Gitlab CI configuration file that creates and runs a pipeline. Its's job is triggered only when a new change makes on branch `develop`. To write a config file assume that we just need to validate `haproxy.cfg` and build a new image based on the new configurations and then push it to the Docker registry. Note that for pushing to docker registry you need to create and define a docker registry in your Gitlab dashboard which its properties will call by variables `$CI_REGISTRY`, `CI_REGISTRY_USER`, and `CI_REGISTRY_PASSWORD`.
