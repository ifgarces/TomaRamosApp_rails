# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing rails commands.
# --------------------------------------------------------------------------------------------------

include .env

# Using this should not be needed, but well, rails is rails.
RAILS_POSTGRES_CONNECTION = "postgresql://cypherdevapp:cypherdevapp@localhost:${POSTGRES_SERVER_PORT}/cypherdevapp_development"

.PHONY: build web_server set_rails assets test _create_db

# Executes migrations, resets database, cleans assets and compiles webpacker
build: set_rails assets
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails db:migrate:reset db:seed --trace

# Runs the server, but not in background
web_server:
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails server --port=${RAILS_SERVER_PORT} --binding=${RAILS_SERVER_HOST}

# Installs dependencies
set_rails:
	bundle install
	yarn install --check-files
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails db:environment:set RAILS_ENV=development

# Updates assets such as CSS styles
assets:
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails assets:clobber assets:precompile

# Run all tests
test:
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails test

# Should be executed only once, when database is blank, when initializing rails on a new machine
_create_db:
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails db:create
