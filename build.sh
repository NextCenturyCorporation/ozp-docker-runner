#!/bin/sh
set -e

# Build the OZP containers
docker build -t ozp-backend ozp-backend
docker build -t ozp-auth ozp-auth
docker build -t ozp-proxy nginx
