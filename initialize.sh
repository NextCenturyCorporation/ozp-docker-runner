#!/bin/sh
set -e

# Usage: ./initialize.sh [--with-sample-data]
#
# This script creates the ozp-media and ozp-database docker volumes and
# populates them with a sqlite database for use by the ozp-backend container.
# By default the database is left empty.  If the --with-sample-data flag is
# specified, the database (and media directory) are populated with sample data.

# Relative path of the directory containing this script
script_dir="$(dirname "$0")"

# Absolute path of the directory containing the script
script_absolute_dir="$(cd "${script_dir}" && pwd)"

# Common args between the two `docker run` commands
run_args=(
    "--entrypoint" "/bin/sh"
    "--rm"
    "--name" "ozp-backend"
    "--link" "ozp-cache"
    "-v" "ozp-database:/var/lib/ozp"
    "-v" "ozp-media:/mnt/media"
    "-v" "${script_absolute_dir}/config:/etc/ozp:ro"
    "-v" "${script_absolute_dir}/logs/ozp-backend:/var/log/ozp"
    "-v" "${script_absolute_dir}/certs:/certs"
    "ozp-backend:latest"
)

# Start the cache and backend and run the commands necessary to get the database built and
# populated with sample data
echo 'Starting Cache'
./start-cache.sh

echo -n 'Creating Database... '
# Everything after the run_args is passed to the entrypoint command (/bin/sh) as arguments
docker run ${run_args[*]} -c 'python manage.py migrate > /var/log/ozp/database_create.log'
echo 'Done'

if [ "$1" == "--with-sample-data" ]; then
    echo -n 'Populating Sample Data... '
    docker run ${run_args[*]} -c 'python manage.py runscript sample_data_generator'
    echo 'Done'
fi

echo 'Stopping Cache'
./stop-cache.sh
