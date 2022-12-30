#!/bin/bash -e
# --------------------------------------------------------------------------------------------------
# Intended to be executed on the deployment server for pulling the codebase and properly
# [re]launching the environment with docker-compose.
#
# Usage
#
#     ./deploy.sh --port WEB_SERVER_PORT [--repo-path PATH] [--branch GIT_BRANCH]
# --------------------------------------------------------------------------------------------------

# Declare arguments
ARGUMENT_LIST=(
    "port"
    "repo-path"
    "branch"
    "help"
)

# Default values
repoPath=${PWD}
branch='master'

# Read arguments
# References: https://gist.github.com/magnetikonline/22c1eb412daa350eeceee76c97519da8
opts=$(getopt \
--longoptions "$(printf "%s:," "${ARGUMENT_LIST[@]}")" \
--name "$(basename "$0")" \
--options "" \
-- "$@")
eval set --$opts
while [[ $# -gt 0 ]]; do
case "$1" in
    --port)
        port=$2
        shift 2
        ;;
    --repo-path)
        repoPath=$2
        shift 2
        ;;
    --branch)
        branch=$2
        shift 2
        ;;
    *)
        break
        ;;
esac
done

set -xu

# Pulling codebase
cd ${repoPath}
git pull origin ${branch}
git checkout ${branch}
git fetch
git status

export RAILS_APP_PORT=${port}

# Building
docker-compose build

# [Re]launching virtualized environment
docker-compose down --remove-orphans
docker-compose up --detach

echo "[OK] Restart done"

docker-compose logs -f tomaramos-rails
