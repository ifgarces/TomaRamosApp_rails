#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Runs the environment virtualized but in development-only mode. Check the DEV docker-compose file.
# --------------------------------------------------------------------------------------------------

DEV_FLAGS='--file docker-compose.yaml --file docker-compose.dev.yaml'

# First ensuring the config file is OK
docker-compose ${DEV_FLAGS} config 1>> /dev/null

docker-compose ${DEV_FLAGS} build
docker-compose ${DEV_FLAGS} down --remove-orphans
docker-compose ${DEV_FLAGS} up --detach postgres html-to-image

set +x
echo "
—————————————————— -- ——————————————————

[OK] Rails dependencies running in virtualized environment. Now you can run your native Rails app.

—————————————————— -- ——————————————————
"

sleep 1
docker-compose logs -f
