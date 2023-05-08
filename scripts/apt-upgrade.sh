#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Exclusive for the production server. Updates OS packages and [re-]launches the web server. This is
# useful because, when upgrading the docker engine (or related packages), containers get stopped.
# --------------------------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update --quiet
sudo apt list --upgradable
sudo apt-get upgrade -y
./deploy.sh
