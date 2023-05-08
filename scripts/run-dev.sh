#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Runs the environment virtualized but in development-only mode, exposing ports for allowing a
# native runtime of Ruby on Rails while using the virtualized database server.
# --------------------------------------------------------------------------------------------------

DEV_FLAGS='--file docker-compose.yaml --file docker-compose.dev.yaml'

# First ensuring the config file is OK
docker-compose ${DEV_FLAGS} config 1>> /dev/null

docker-compose ${DEV_FLAGS} build
docker-compose ${DEV_FLAGS} down --remove-orphans
docker-compose ${DEV_FLAGS} up --detach postgres html-to-image

docker-compose ${DEV_FLAGS} ps

set +x
echo "[OK] Rails dependencies running in virtualized environment. Now you can run your native Rails app:
    cd TomaRamosWebApp && make web_server
"
