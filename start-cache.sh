#!/bin/sh

#Check to see if its already running
if [ $(docker ps | grep ozp-cache | wc -l) == "0" ]; then
    docker run --name ozp-cache -d redis:3.2-alpine
fi
