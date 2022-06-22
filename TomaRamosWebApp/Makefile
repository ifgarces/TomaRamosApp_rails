# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing rails commands.
# --------------------------------------------------------------------------------------------------

include ../.env

# Using this should not be needed, but well, rails is rails.
RAILS_POSTGRES_CONNECTION = "postgresql://tomaramosuandes:tomaramosuandes@localhost:${POSTGRES_PORT}/tomaramos_development"

.PHONY: build web_server set_rails assets test _create_db

# Executes migrations, resets database, cleans assets and compiles javascript
build: set_rails assets
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails db:migrate:reset db:seed --trace

# Runs the server, but not in background
web_server:
	DATABASE_URL=${RAILS_POSTGRES_CONNECTION} \
		rails server --port=${WEB_SERVER_PORT} --binding=${WEB_SERVER_HOST}

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
