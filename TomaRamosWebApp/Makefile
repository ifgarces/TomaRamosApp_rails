# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing rails commands.
# --------------------------------------------------------------------------------------------------

include ../.env
include ../.secrets.env

# Using explicit ENV variables for database config, which should not be needed, but Rails refuses to
# correctly use the `datatabse.yml` for some reason
DB_URL_DEVELOPMENT = "postgresql://tomaramosuandes:tomaramosuandes@localhost:${POSTGRES_PORT}/tomaramosuandes_development"
DB_URL_TEST = "postgresql://tomaramosuandes:tomaramosuandes@localhost:${POSTGRES_PORT}/tomaramosuandes_test"

RUNTIME_ENVIRONMENT = development

.PHONY: build web_server import_csv migrate seed packages assets clear_sessions test

# Executes migrations, resets database, cleans assets and compiles javascript
build: packages assets migrate seed import_csv

# Runs the server, but not in background
web_server:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
	OAUTH_CLIENT_ID=${OAUTH_CLIENT_ID} \
	OAUTH_CLIENT_SECRET=${OAUTH_CLIENT_SECRET} \
		rails server \
			--port=${WEB_SERVER_PORT} \
			--binding=${WEB_SERVER_HOST} \
			--environment=${RUNTIME_ENVIRONMENT} \
			--no-log-to-stdout

#! This rule is for debugging-only
# This one is intended for the server only
https_web_server:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
	OAUTH_CLIENT_ID=${OAUTH_CLIENT_ID} \
	OAUTH_CLIENT_SECRET=${OAUTH_CLIENT_SECRET} \
		rails server \
			--using=puma \
			--binding="ssl://${WEB_SERVER_HOST}:${WEB_SERVER_PORT}?key=/etc/ssl/certs/tomaramos.app.key&cert=/etc/ssl/certs/tomaramos.app-bundle.crt" \
			--environment=${RUNTIME_ENVIRONMENT} \
			--no-log-to-stdout

# Runs the task for importing course data
import_csv:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rake data_importer:csv --trace

#// rails db:migrate:reset --trace
migrate:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails db:migrate --trace

seed:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
	OAUTH_CLIENT_ID=${OAUTH_CLIENT_ID} \
	OAUTH_CLIENT_SECRET=${OAUTH_CLIENT_SECRET} \
	ADMIN_USER_PASSWORD=${ADMIN_USER_PASSWORD} \
		rails db:seed --trace

# Installs Ruby and JavaScript dependencies
packages:
	bundle install
	yarn install --check-files
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails db:environment:set RAILS_ENV=${RUNTIME_ENVIRONMENT}

# Updates assets such as CSS styles
assets:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails assets:clobber assets:precompile

clear_sessions:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rake tmp:clear

# Run all Rails tests
test:
	DATABASE_URL=${DB_URL_TEST} \
		rails test