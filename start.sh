#!/bin/sh
set -e

# Relative path of the directory containing this script
script_dir="$(dirname "$0")"

# Absolute path of the directory containing the script
script_absolute_dir="$(cd "${script_dir}" && pwd)"

# Auth Server
docker run \
    --name ozp-auth \
    -v "${script_absolute_dir}/logs/ozp-auth:/var/log/ozp-auth" \
    -d \
    ozp-auth:latest

# Backend
# Mount "named volumes" for the database and media.
# Mount the ozp-config directory.  Use a specific host directory
# for this so that the user can easily modify the configs.  Read-only to the container
docker run \
    --name ozp-backend \
    --link ozp-auth \
    -v ozp-database:/var/lib/ozp \
    -v ozp-media:/mnt/media \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -v "${script_absolute_dir}/logs/ozp-backend:/var/log/ozp" \
    -v "${script_absolute_dir}/certs:/certs" \
    -d \
    ozp-backend:latest

# Reverse Proxy
docker run \
    --name ozp-proxy \
    --link ozp-backend \
    -v "${script_absolute_dir}/logs/nginx:/var/log/nginx" \
    -v "${script_absolute_dir}/certs:/certs" \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -d \
    -p 8080:80 \
    -p 8443:443 \
    ozp-proxy:latest
