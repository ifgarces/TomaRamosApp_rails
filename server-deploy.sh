#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
# --------------------------------------------------------------------------------------------------

set -exu

git fetch
git pull origin main
./restart-rails.sh
git fetch && git status

sleep 5 && docker-compose ps
