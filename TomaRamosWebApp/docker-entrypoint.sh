#!/bin/bash -exu
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

# For some reason, when running virtualized, this will be required as Rails refuses to properly load
# the required .env files
erb ./config/database.yml >> ./config/database.yml

# Creating database for eventually running virtualized tests
RAILS_ENV=test rails db:create

export RAILS_ENV=development

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
