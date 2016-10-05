# OZP Docker Installation and Running Scripts
This repository contains files that facilitate the download, installation, and
running of the OZP docker images.  Additionally, directories are included
which provide easy access to certs and logs used by the containers.

### Prerequisites
* Docker Engine
* Docker Compose (included in newer releases of Docker Engine)

## Quick Start
Execute the following command to start OZP:
`docker-compose up`

## Configuration
Commonly-used configurations can be set using environment variables which can be
defined in ozp-variables.env.  The following variables are supported, and affect
the corresponding properties in the OZP backend's settings.py file:

* OZP_DB_ENGINE
* OZP_DB_NAME
* OZP_DB_USER
* OZP_DB_PASSWORD
* OZP_DB_HOST
* OZP_DB_PORT
* OZP_DB_APP_ROOT (default: https://localhost:8443/)

_Note: If changing the database settings, you will also need to adjust the
`image` line in docker-compose.yml.  See the description of ozp-backend, images below
for more details._

If more detailed customizations to configuration are desired, the configration
file can be copied out of the OZP container using the following command:

`docker cp ozp-backend:/etc/ozp/backend-settings.py ./config/`

After that, the file can be edited in the host's config directory and mounted
into a new container as a volume by uncommenting the appropriate line in
`docker-compose.yml`

## The OZP Images
OZP is split into the following three Docker images:

### ozp-auth
The sample authentication and authorization server for OZP.  This image
represents a dummy implementation of a RESTful user information service which
OZP can use to retrieve updated information about users who have logged in.
ozp-auth containers run a gunicorn process on port 8000.  This container is
exposed to others under the hostname `ozp-auth`.

### ozp-backend
The application server backend for OZP.  Containers based on this image expose a
REST service, using gunicorn on port 8000 which can respond to both HTTP and
HTTPS requests.  When started using docker-compose, containers of this image have
the following externally exposed files:
* `logs/ozp-backend/` - This directory contains log files output by OZP.
    gunicorn_ozp.log contains the Gunicorn process' output.  ozp.log contains
    the OZP application's JSON-formatted logs.
* `certs/` - This directory contains the sample TLS certificates that are used
    by both this container and the ozp-proxy container.  Replace the samples
    with real certificates for production

This container is exposed to others under the hostname `ozp-backend`.

#### Images
There are actually three possible images that this container can be run from, as
described below.  The default image is ozp-backend-sample-data

* ozp-backend: This is the base image for ozp-backend.  To use it you must set
    at least some of the OZP_DB_* environment variables to point to your
    preferred database
* ozp-backend-sqlite: This image builds on top of ozp-backend by pre-configuring
    a sqlite database.  The database settings are already configured and the OZP
    database schema is already populated into a sqlite file that is stored in a
    volume
* ozp-backend-sample-data: This image builds on ozp-backend-sqlite by populating
    the sqlite database and media directory with sample data, including sample
    users

### ozp-proxy
The reverse proxy which serves the OZP frontend and acts as a gateway for the
backend.  When started using `start.sh`, containers of this image use the
following directories:
* `logs/nginx` - Contains the nginx log files
* `certs/` - This directory contains the sample TLS certificates that are used
    by both this container and the ozp-backend container.  Replace the samples
    with real certificates for production

This container's HTTPS port is exposed as host port 8443.
