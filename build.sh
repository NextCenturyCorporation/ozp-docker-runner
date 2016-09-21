#!/bin/sh
set -e

. ./lib.sh

# Build the OZP containers
for c in "${containers[@]}"; do
    docker build -t "${docker_registry}/${c}" $c
done
