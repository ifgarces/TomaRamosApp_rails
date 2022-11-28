#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

set -exu

echo "[debug] DATABASE_URL=${DATABASE_URL}"
echo "[debug] SERVE_OVER_HTTPS=${SERVE_OVER_HTTPS}"

# Compiling assets and initializing database
#// rails db:create
#// rails db:migrate:reset db:seed
rails db:migrate db:seed
rails assets:clobber assets:precompile

# Filling/updating database with data parsed from CSV
rake data_importer:csv --trace

# Starting web server, logging to STDOUT/STDERR
if [[ "${SERVE_OVER_HTTPS}" == "true" ]]; then
    #! UGLY temporal workaround, must properly use production environment instead!
    sed -i 's/config.consider_all_requests_local = true/config.consider_all_requests_local = false/' ./config/environments/development.rb
    sed -i 's/# config.force_ssl = true/config.force_ssl = true/' ./config/environments/development.rb

    #! Testing localhost now
    echo "
[ req ]
prompt                 = no
days                   = 365
distinguished_name     = req_distinguished_name
req_extensions         = v3_req

[ req_distinguished_name ]
countryName            = CL
stateOrProvinceName    = Metropolitana
localityName           = Santiago
organizationName       = tomaramos.app
organizationalUnitName = ifgarces
commonName             = localhost
emailAddress           = hostmaster@tomaramos.app

[ v3_req ]
basicConstraints       = CA:false
extendedKeyUsage       = serverAuth
subjectAltName         = @sans

[ sans ]
DNS.0 = localhost
DNS.1 = localhost
    " >> ca-config.temp.conf

    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -utf8 \
        -keyout /etc/ssl/certs/tomaramos.app.key \
        -out /etc/ssl/certs/tomaramos.app.crt \
        -config ca-config.temp.conf
        #"/C=CL/ST=Región Metropolitana/L=Santiago/O=TomaRamosApp/OU=/CN=/emailAddress="

    # References: https://stackoverflow.com/a/31939157/12684271
    echo "::: SERVING OVER HTTPS :::"
    rails server \
        --using=puma \
        --binding="ssl://${WEB_SERVER_HOST}:${WEB_SERVER_PORT}?key=/etc/ssl/certs/tomaramos.app.key&cert=/etc/ssl/certs/tomaramos.app.crt&verify_mode=none" \
        --environment=development
elif [[ "${SERVE_OVER_HTTPS}" == "false" ]]; then
    rails server \
        --port=${WEB_SERVER_PORT} \
        --binding=${WEB_SERVER_HOST}
else
    echo "SERVE_OVER_HTTPS: Invalid non-boolean value \"${SERVE_OVER_HTTPS}\"" >&2
    exit 1
fi
