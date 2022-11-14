#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Builds and re-launches the Ruby on Rails web server container, leaving the Postgres container
# untouched, preserving database. Note that, if the Rails build fails, the currently running Rails
# container will be preserved.
# --------------------------------------------------------------------------------------------------

set -ex

# Default protocol is HTTP, only for now
if [ -z ${SERVE_OVER_HTTPS} ]; then
    SERVE_OVER_HTTPS=false
fi

set -u

export SERVE_OVER_HTTPS=${SERVE_OVER_HTTPS}

# Re-launching Rails web server container
docker-compose build tomaramos-rails
docker-compose rm --stop --force -v tomaramos-rails
docker-compose up --detach tomaramos-rails

# Copying HTTPS certificates accordingly (production server only)
if [[ "${SERVE_OVER_HTTPS}" == "true" ]]; then
    docker cp /etc/ssl/certs/tomaramos.app-bundle.crt tomaramos-rails-container:/etc/ssl/certs/
    docker cp /etc/ssl/certs/tomaramos.app.key        tomaramos-rails-container:/etc/ssl/certs/
fi
