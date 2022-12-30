#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database and other dependencies, for
# finally starting the Rails web application.
# --------------------------------------------------------------------------------------------------

# Creating test database (for containerized Rails tests)
DATABASE_URL="postgresql://tomaramosuandes:tomaramosuandes@tomaramos-postgres:${POSTGRES_PORT}/tomaramosuandes_test" \
    rails db:create

# Compiling assets and initializing database
rails assets:clobber assets:precompile
rails db:create
rails db:migrate db:seed

# Filling/updating database with data parsed from CSV
rake data_importer:csv --trace

# Starting web server, outputting Rails logging to STDOUT/STDERR
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

    SSL_CERT_PATH=/etc/ssl/certs/tomaramos.app.crt
    SSL_KEY_PATH=/etc/ssl/certs/tomaramos.app.key

    # Creating self-signed SSL certificate
    openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -utf8 \
        -keyout SSL_KEY_PATH \
        -out SSL_CERT_PATH \
        -config ca-config.temp.conf
        #"/C=CL/ST=Región Metropolitana/L=Santiago/O=TomaRamosApp/OU=/CN=/emailAddress="

    # References: https://stackoverflow.com/a/31939157/12684271
    echo "::: SERVING OVER HTTPS :::"
    BIND_OVERRIDE=ssl://0.0.0.0:${RAILS_APP_PORT}?key=${SSL_KEY_PATH}&cert=${SSL_CERT_PATH}&verify_mode=none \
        rails server \
            --using=puma \
            --environment=development \
            --pid=/tmp/rails.pid

elif [[ "${SERVE_OVER_HTTPS}" == "false" ]]; then
    BIND_OVERRIDE=unix:///tmp/sockets/rails_app.sock \
        rails server \
            --using=puma \
            --environment=development \
            --pid=/tmp/rails.pid

else
    echo "SERVE_OVER_HTTPS: invalid non boolean-like value \"${SERVE_OVER_HTTPS}\"" >&2
    exit 1
fi
