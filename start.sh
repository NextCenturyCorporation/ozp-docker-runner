#!/bin/sh
set -e

. ./lib.sh

script_absolute_dir="$(get_script_absolute_dir)"

# Redis cache server
start_cache

# Auth Server
docker run \
    --name ozp-auth \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -v "${script_absolute_dir}/logs/ozp-auth:/var/log/ozp" \
    -d \
    "${docker_registry}/ozp-auth:latest"

# Backend
# Mount "named volumes" for the database and media.
# Mount the host directories for config, logs, and certs
docker run \
    --name ozp-backend \
    --link ozp-auth \
    --link ozp-cache \
    -v ozp-database:/var/lib/ozp \
    -v ozp-media:/mnt/media \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -v "${script_absolute_dir}/logs/ozp-backend:/var/log/ozp" \
    -v "${script_absolute_dir}/certs:/certs:ro" \
    -d \
    "${docker_registry}/ozp-backend:latest"

# Reverse Proxy
docker run \
    --name ozp-proxy \
    --link ozp-backend \
    -v "${script_absolute_dir}/logs/nginx:/var/log/nginx" \
    -v "${script_absolute_dir}/certs:/certs:ro" \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -d \
    -p 8080:80 \
    -p 8443:443 \
    "${docker_registry}/ozp-proxy:latest"
