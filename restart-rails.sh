#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Builds and re-launches the Ruby on Rails web server container, leaving the Postgres container
# untouched, preserving database.
# --------------------------------------------------------------------------------------------------

set -exu

export SERVE_OVER_HTTPS=${SERVE_OVER_HTTPS}

docker-compose build tomaramos-rails

# Deleting web server container and stopping postgres
docker-compose rm --stop --force -v tomaramos-rails
docker-compose stop tomaramos-postgres

# Launching web server container, copying HTTPS certificates, resuming postgres
docker-compose up --detach tomaramos-rails

if [[ "${SERVE_OVER_HTTPS}" == "true" ]]; then
    docker cp /etc/ssl/certs/tomaramos.app-bundle.crt tomaramos-rails-container:/etc/ssl/certs/
    docker cp /etc/ssl/certs/tomaramos.app.key        tomaramos-rails-container:/etc/ssl/certs/
fi

docker-compose start tomaramos-postgres
