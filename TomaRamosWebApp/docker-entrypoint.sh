#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

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
rails server \
    --port=${WEB_SERVER_PORT} \
    --binding=0.0.0.0 \
    --environment=development
