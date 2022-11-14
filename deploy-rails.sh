#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
#
# Note: `TOMARAMOSAPP_RAILS` has to be defined, as the absolute route where this repository is
# cloned at the production server.
# --------------------------------------------------------------------------------------------------

set -exu

cd ${TOMARAMOSAPP_RAILS}

git pull origin main
git fetch && git status

# Launching postgres server if not running
# References: https://serverfault.com/a/935674
if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q tomaramos-postgres)` ]; then
    docker-compose up --build --detach tomaramos-postgres
fi

./restart-rails.sh
./restart-html-to-image.sh

docker-compose logs -f tomaramos-rails
