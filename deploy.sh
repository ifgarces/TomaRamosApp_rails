#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the main branch and refreshing Rails.
#
# Note: `TOMARAMOSAPP_RAILS` has to be defined, as the absolute route where this repository is
# cloned at the production server.
# --------------------------------------------------------------------------------------------------

set -eu

LOG_FILE="./deploy.log"
date > ${LOG_FILE} 
echo "Outputting to ${LOG_FILE}"

set -x

cd ${TOMARAMOSAPP_RAILS}

git pull origin master | tee -a ${LOG_FILE}
git fetch | tee -a ${LOG_FILE}
git status | tee -a ${LOG_FILE}

# Launching postgres server if not running
# References: https://serverfault.com/a/935674
if [ -z `docker ps -q --no-trunc | grep $(docker-compose ps -q tomaramos-postgres)` ]; then
    docker-compose up --build --detach tomaramos-postgres | tee -a ${LOG_FILE}
fi

./restart-rails.sh | tee -a ${LOG_FILE}
./restart-html-to-image.sh | tee -a ${LOG_FILE}
echo "[OK] Restart done" >> ${LOG_FILE}

docker-compose logs -f tomaramos-rails
