# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing developing rails commands.
# --------------------------------------------------------------------------------------------------

include ../.env
# include ../.secrets.env #! unused

.PHONY: build web_server import_csv migrate seed packages assets clear_sessions test

# Executes migrations, resets database, cleans assets and compiles javascript
build: packages assets migrate seed import_csv

# Runs the server
web_server:
	rails server \
		--port=${WEB_SERVER_PORT} \
		--binding=localhost \
		--environment=development \
		--no-log-to-stdout

# Runs the task for importing course data
import_csv:
	rake data_importer:csv --trace

migrate:
	rails db:migrate --trace

seed:
	ADMIN_PASSWORD=qwerty rails db:seed --trace

# Installs Ruby and JavaScript dependencies
packages:
	bundle install
	yarn install --check-files

# Updates assets such as CSS styles
assets:
	rails assets:clobber assets:precompile

clear_old_guest_users:
	rake data_cleaner:guest_users --trace

# Run all Rails tests
test:
	rails test --environment=test
	#~~~~~~= [OK] Tests went fine =~~~~~~#

__clear_sessions:
	rake tmp:clear

__debug_clear_database:
	rails db:migrate:reset --trace
