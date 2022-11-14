#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Builds and re-launches the http-to-image service.
# --------------------------------------------------------------------------------------------------

set -exu

docker-compose build http-to-image
docker-compose rm --stop --force -v http-to-image
docker-compose up --detach http-to-image
