#!/bin/sh
set -e

# Relative path of the directory containing this script
script_dir="$(dirname "$0")"

# Absolute path of the directory containing the script
script_absolute_dir="$(cd "${script_dir}" && pwd)"

# Auth Server
docker run --name ozp-auth -d ozp-auth:latest

# Backend
# Mount "named volumes" for the database and media.
# Mount the ozp-config directory.  Use a specific host directory
# for this so that the user can easily modify the configs.  Read-only to the container
docker run \
    --name ozp-backend \
    --link ozp-auth \
    -v ozp-database:/ozp-database \
    -v ozp-media:/ozp-media \
    -v "${script_absolute_dir}/ozp-config:/ozp-config:ro" \
    -v "${script_absolute_dir}/backend-logs:/ozp-logs" \
    -d \
    ozp-backend:latest

# Reverse Proxy
# Mount the ozp-media volume here too for direct serving of
# media files (images)
docker run \
    --name ozp-proxy \
    --link ozp-backend \
    -d \
    -v ozp-media:/ozp-media:ro \
    -p 8080:80 \
    -p 8443:443 \
    ozp-proxy:latest
