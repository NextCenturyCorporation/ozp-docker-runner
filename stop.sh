#!/bin/sh

containers=( ozp-backend ozp-auth ozp-proxy )

echo 'STOPPING'
docker stop ${containers[*]}

echo 'REMOVING'
docker rm ${containers[*]}

echo 'STOPPING AND REMOVING CACHE'
./stop-cache.sh
