#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
#
# Note: `TOMARAMOSAPP_RAILS` has to be defined (e.g. "/home/ifgarces/TomaRamosUandes_rails")
# --------------------------------------------------------------------------------------------------

set -exu

cd ${TOMARAMOSAPP_RAILS}

git pull origin main
git fetch && git status

./restart-rails.sh
docker-compose logs -f tomaramos-rails
