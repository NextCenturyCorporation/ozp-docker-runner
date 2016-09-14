#!/bin/sh
set -e

# Relative path of the directory containing this script
script_dir="$(dirname "$0")"

# Absolute path of the directory containing the script
script_absolute_dir="$(cd "${script_dir}" && pwd)"

# Build the OZP containers
docker build -t ozp-backend ozp-backend
docker build -t ozp-auth ozp-auth
docker build -t ozp-proxy nginx

# Start the cache and backend and run the commands necessary to get the database built and
# populated with sample data
echo 'Populating database'
./start-cache.sh
docker run \
    --entrypoint /release/sample-database.sh \
    --rm \
    --name ozp-backend \
    --link ozp-cache \
    -v ozp-database:/var/lib/ozp \
    -v ozp-media:/mnt/media \
    -v "${script_absolute_dir}/config:/etc/ozp:ro" \
    -v "${script_absolute_dir}/logs/ozp-backend:/var/log/ozp" \
    -v "${script_absolute_dir}/certs:/certs" \
    ozp-backend:latest


./stop-cache.sh
echo 'Done Populating database'
