#!/bin/sh
# --------------------------------------------------------------------------------------------------
# Server initialization script that creates and seeds the database, and finally runs the rails web
# server, executed when the container starts.
# --------------------------------------------------------------------------------------------------

set -exu

echo "[debug] DATABASE_URL=${DATABASE_URL}"

# Compiling assets and initializing database
rails db:create
rails db:migrate:reset db:seed
rails assets:clobber assets:precompile

# Filling database with data parsed from CSV
rake data_importer:csv --trace

# Starting web server
rails server --port=${WEB_SERVER_PORT} --binding=${WEB_SERVER_HOST}
