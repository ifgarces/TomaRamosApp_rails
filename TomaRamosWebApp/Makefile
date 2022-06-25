# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing rails commands.
# --------------------------------------------------------------------------------------------------

include ../.env

# Using explicit ENV variables for database config, which should not be needed, but Rails refuses to
# correctly use the `datatabse.yml` for some reason
DB_URL_DEVELOPMENT = "postgresql://tomaramosuandes:tomaramosuandes@localhost:${POSTGRES_PORT}/tomaramosuandes_development"
DB_URL_TEST = "postgresql://tomaramosuandes:tomaramosuandes@localhost:${POSTGRES_PORT}/tomaramosuandes_test"

.PHONY: build web_server import_csv packages assets test

# Executes migrations, resets database, cleans assets and compiles javascript
build: packages assets
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails db:migrate:reset db:seed --trace

# Runs the server, but not in background
web_server:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails server --port=${WEB_SERVER_PORT} --binding=${WEB_SERVER_HOST}

# Runs the task for importing course data
import_csv:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rake data_importer:csv_all --trace

# Installs Ruby and JavaScript dependencies
packages:
	bundle install
	yarn install --check-files
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails db:environment:set RAILS_ENV=development

# Updates assets such as CSS styles
assets:
	DATABASE_URL=${DB_URL_DEVELOPMENT} \
		rails assets:clobber assets:precompile

# Run all Rails tests
test:
	DATABASE_URL=${DB_URL_TEST} \
		rails test
