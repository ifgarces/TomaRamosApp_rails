#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Builds and re-launches the html-to-image service.
# --------------------------------------------------------------------------------------------------

set -exu

docker-compose build html-to-image
docker-compose rm --stop --force -v html-to-image
docker-compose up --detach html-to-image
