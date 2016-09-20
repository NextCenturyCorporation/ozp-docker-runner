#!/bin/sh
set -e

# Build the OZP containers
for c in ozp-{backend,auth,proxy}; do
    docker build -t $c $c
done
