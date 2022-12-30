#!/bin/bash
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

set -exu

# Creating tests database
DATABASE_URL="postgresql://tomaramosuandes:tomaramosuandes@tomaramos-postgres:${POSTGRES_PORT}/tomaramosuandes_test" \
    rails db:create

# Compiling assets and initializing database
rails db:create
rails db:migrate db:seed
rails assets:clobber assets:precompile

# Filling/updating database with data parsed from CSV
rake data_importer:csv --trace

# Starting web server, logging to STDOUT/STDERR
if [[ "${SERVE_OVER_HTTPS}" == "true" ]]; then
    #! Local dev SSL certificate

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
organizationName       = localhost
organizationalUnitName = R&D
commonName             = localhost
emailAddress           = hostmaster@tomaramos.app

[ v3_req ]
basicConstraints       = CA:false
extendedKeyUsage       = serverAuth
subjectAltName         = @sans

[ sans ]
DNS.0 = localhost
DNS.1 = localhost
    " >> /tmp/local-ca-config.conf

    SSL_KEY_PATH=/tmp/localhost.key
    SSL_CERT_PATH=/tmp/localhost.crt

    # Creating self-signed SSL certificate
    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -utf8 \
        -keyout ${SSL_KEY_PATH} \
        -out ${SSL_CERT_PATH} \
        -config /tmp/local-ca-config.conf

    # References: https://stackoverflow.com/a/31939157/12684271
    echo "::: SERVING OVER HTTPS :::"
    FORCE_SSL=1 \
    rails server \
        --using=puma \
        --binding="ssl://0.0.0.0:${WEB_SERVER_PORT}?key=${SSL_KEY_PATH}&cert=${SSL_CERT_PATH}&verify_mode=none" \
        --environment=development

elif [[ "${SERVE_OVER_HTTPS}" == "false" ]]; then
    rails server \
        --port=${WEB_SERVER_PORT} \
        --binding=0.0.0.0 \
        --environment=development

else
    echo "SERVE_OVER_HTTPS: Invalid non-boolean value \"${SERVE_OVER_HTTPS}\"" >&2
    exit 1
fi
