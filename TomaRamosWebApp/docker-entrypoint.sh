#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

set -exu

echo "[debug] DATABASE_URL=${DATABASE_URL}"
echo "[debug] SERVE_OVER_HTTPS=${SERVE_OVER_HTTPS}"

# Compiling assets and initializing database
rails db:create
rails db:migrate:reset db:seed
rails assets:clobber assets:precompile

# Filling database with data parsed from CSV
rake data_importer:csv --trace

# Starting web server, logs Rails stuff to the default `logs/development.log` instead of STDOUT
if [[ "${SERVE_OVER_HTTPS}" == "true" ]]; then
    #! UGLY temporal workaround, must properly use production environment instead!
    sed -i 's/config.consider_all_requests_local = true/config.consider_all_requests_local = false/' ./TomaRamosWebApp/config/environments/development.rb
    sed -i 's/# config.force_ssl = true/config.force_ssl = true/' ./TomaRamosWebApp/config/environments/development.rb

    # References: https://stackoverflow.com/a/31939157/12684271
    rails server \
        --using=puma \
        --binding="ssl://${WEB_SERVER_HOST}:${WEB_SERVER_PORT}?key=/etc/ssl/certs/tomaramos.app.key&cert=/etc/ssl/certs/tomaramos.app-bundle.crt&verify_mode=none" \
        --environment=development \
        --no-log-to-stdout
elif [[ "${SERVE_OVER_HTTPS}" == "false" ]]; then
    rails server \
        --port=${WEB_SERVER_PORT} \
        --binding=${WEB_SERVER_HOST} \
        --no-log-to-stdout
else
    echo "Invalid value ${SERVE_OVER_HTTPS} for boolean-like value" >&2
    exit 1
fi
