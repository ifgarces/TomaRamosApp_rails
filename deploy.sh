#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
#
# Note: `TOMARAMOSAPP_RAILS` has to be defined, as the absolute route where this repository is
# cloned at the production server.
# --------------------------------------------------------------------------------------------------

set -exu

cd ${TOMARAMOSAPP_RAILS}

# Pulling codebase
git pull origin master
git checkout master
git fetch
git status

# Building
docker-compose build

# Re-launching virtualized environment
docker-compose down --remove-orphans
docker-compose up --detach

echo "[OK] Restart done"

docker-compose logs -f tomaramos-rails
