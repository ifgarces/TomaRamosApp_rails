#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Runs the environment virtualized but in development-only mode. See the dev docker-compose file.
# --------------------------------------------------------------------------------------------------

DEV_FLAGS='--file docker-compose.yaml --file docker-compose.dev.yaml'

# First ensuring the config file is OK
docker-compose ${DEV_FLAGS} config 1> /dev/null

docker-compose ${DEV_FLAGS} build
docker-compose ${DEV_FLAGS} down --remove-orphans
docker-compose ${DEV_FLAGS} up --detach postgres html-to-image

set +x

echo "
----------------------------------------------------------------------------------------------------
[OK] Virtualized environment running in DEVELOPMENT mode. Now the virtualized Rails web app will \
start, with volume mount on all source files. You can also hit CTRL+C to stop this virtualized \
Rails and go to the Rails directory and run it natively instead, using make commands.
----------------------------------------------------------------------------------------------------
"

docker-compose ${DEV_FLAGS} up rails
