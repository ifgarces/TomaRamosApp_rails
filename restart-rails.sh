#!/bin/sh
# --------------------------------------------------------------------------------------------------
# Builds and re-launches the web server container, leaving the Postgres container untouched,
# preserving database.
# --------------------------------------------------------------------------------------------------

set -exu

docker-compose build

# Deleting web server container and stopping postgres
docker-compose down tomaramos-rails
docker-compose stop tomaramos-postgres

# Launching web server container, copying HTTPS certificates, resuming postgres
docker-compose up tomaramos-rails --detach
docker cp /etc/ssl/certs/tomaramos.app-bundle.crt tomaramos-rails-container:/etc/ssl/certs/
docker cp /etc/ssl/certs/tomaramos.app.key        tomaramos-rails-container:/etc/ssl/certs/
docker-compose start tomaramos-postgres
