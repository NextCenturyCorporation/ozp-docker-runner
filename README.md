# OZP Docker Installation and Running Scripts
This repository contains scripts that facilitate the download, installation, and
running the the OZP docker images.  Additionally, directories are included
which provide easy access to configurations and logs used by the containers.

## Quick Start
Execute the following scripts to start OZP:
`./initialize.sh --with-sample-data`
`./start.sh`

To shut OZP down, execute this script:
`./stop.sh`

## Detailed Instructions
The following scripts can be used to control the OZP docker containers.

_Note: Docker will download any needed images that it doesn't already have.  You
will notice the first runs of the following scripts downloading the images
automatically._

### initialize.sh
This script starts a temporary instance of the ozp-backend container and uses it
to generate the sqlite database which persists OZP data.  When run with the
`--with-sample-data` flag, this script will also populate the database and
uploaded media directory with initial sample data, including user profiles.
Note that right now, these pre-populated user profiles seem to be the only way
to successfully login to OZP.

### start.sh
This script starts all three of the OZP images, along with a Redis cache
container, as daemon containers.  The containers are started such that the OZP
web UI can be reached at https://localhost:8443/ozp-center .

_Note: If you are using Docker Machine, you will need to replace `localhost`
above with the IP address of the Docker Machine VM._

### stop.sh
This script stops the OZP containers, including the Redis cache.

## The OZP Images
OZP is split into the following three Docker images:

### ozp-auth
The sample authentication and authorization server for OZP.  This image
represents a dummy implementation of a RESTful user information service which
OZP can use to retrieve updated information about users who have logged in.
ozp-auth containers run a gunicorn process on port 8000.  When started using
`start.sh`, containers using this image are configured using the
`config/auth-settings.py` file.  Logs are output to `logs/ozp-auth`.  This
container is exposed to others under the hostname `ozp-auth`.

### ozp-backend
The application server backend for OZP.  Containers based on this image expose a
REST service, using gunicorn on port 8000 which can respond to both HTTP and
HTTPS requests.  When started using `start.sh`, containers of this image have
the following externally exposed files:
* `config/backend-settings.py` - the primary Django settings file. This is where
    caching, database, and authentication settings can be changed.
* `logs/ozp-backend/` - This directory contains log files output by OZP.
    gunicorn_ozp.log contains the Gunicorn process' output.  ozp.log contains
    the OZP application's JSON-formatted logs.
* `certs/` - This directory contains the sample TLS certificates that are used
    by both this container and the ozp-proxy container.  Replace the samples
    with real certificates for production

Additionally, the following named persistent volumes are used:
* `ozp-database` - Contains the sqlite database file
* `ozp-media` - Contains uploaded images such as Listing icons

This container is exposed to others under the hostname `ozp-backend`.

### ozp-proxy
The reverse proxy which serves the OZP frontend and acts as a gateway for the
backend.  When started using `start.sh`, containers of this image use the
following directories:
* `logs/nginx` - Contains the nginx log files
* `certs/` - This directory contains the sample TLS certificates that are used
    by both this container and the ozp-backend container.  Replace the samples
    with real certificates for production
* `config/OzoneConfig.js` - Configuration settings for the OZP frontend
    applications

`start.sh` also binds port 8443 for this container, HTTPS accesss
