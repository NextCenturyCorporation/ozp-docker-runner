#!/bin/sh

docker run --name ozp-backend -d ozp-backend:latest
docker run --name ozp-auth -d ozp-auth:latest
docker run \
    --name ozp-proxy \
    --link ozp-backend \
    --link ozp-auth \
    -d \
    -p 8080:80 \
    -p 8443:443 \
    ozp-proxy:latest
