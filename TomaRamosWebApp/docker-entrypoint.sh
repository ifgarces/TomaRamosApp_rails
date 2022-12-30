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
    #! Testing localhost now

    # References: https://stackoverflow.com/a/31939157/12684271
    echo "::: SERVING OVER HTTPS :::"
    FORCE_SSL=1 \
    BIND_OVERRIDE="ssl://0.0.0.0:8888?key=${SSL_KEY_FILE}&cert=${SSL_CERT_FILE}&verify_mode=none" \
        rails server \
            --using=puma \
            --environment=development \
            --pid=/tmp/rails.pid

elif [[ "${SERVE_OVER_HTTPS}" == "false" ]]; then
    #BIND_OVERRIDE=unix:///tmp/sockets/rails_app.sock
        rails server \
            --port=8888 \
			--binding=0.0.0.0 \
            --using=puma \
            --environment=development \
            --pid=/tmp/rails.pid

else
    echo "SERVE_OVER_HTTPS: invalid non boolean-like value \"${SERVE_OVER_HTTPS}\"" >&2
    exit 1
fi
