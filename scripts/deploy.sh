#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
#
# Note: `TOMARAMOSAPP_RAILS` has to be defined, as the absolute route where this repository is
# cloned at the production server.
# --------------------------------------------------------------------------------------------------

cd ${TOMARAMOSAPP_RAILS}

# Pulling codebase
git pull origin master
git checkout master
git fetch
git status

# Building
docker-compose build

# Re-launching virtualized environment
docker-compose down --remove-orphans --timeout 20
docker-compose up --detach

echo "[OK] Restart done"
