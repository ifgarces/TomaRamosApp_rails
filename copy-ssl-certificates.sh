#!/bin/sh
# --------------------------------------------------------------------------------------------------
# Copy SSL certificates for enabling HTTPS on the Rails container.
# --------------------------------------------------------------------------------------------------

set -exu

docker cp /etc/ssl/certs/tomaramos.app-bundle.crt tomaramos-rails-container:/etc/ssl/certs/
docker cp /etc/ssl/certs/tomaramos.app.key tomaramos-rails-container:/etc/ssl/certs/
