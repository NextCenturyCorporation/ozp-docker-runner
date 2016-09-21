#!/bin/sh
set -e

. ./lib.sh

# Build the OZP containers
for c in "${containers[@]}"; do
    docker push "${docker_registry}/${c}"
done
