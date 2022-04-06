# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing build commands.
# --------------------------------------------------------------------------------------------------

# Setting quiet mode by default (not printing rules when executing them)
ifndef VERBOSE
.SILENT:
endif

PORT = 9090
HOST = 0.0.0.0

# Runs the server, but not in background
foreground_server: stop_server
	rails server --port=${PORT} --binding=${HOST}

# Runs the server in background
background_server: stop_server
	rails server --port=${PORT} --binding=${HOST} --daemon

# Views server output, when running in background
output:
	tail -f ./log/development.log -n 60

#* Stops the server, if running at background
stop_server:
	if [ -f "./tmp/pids/server.pid" ]; then \
		kill $$(cat "./tmp/pids/server.pid"); \
		echo "Server stopped."; \
		rm -f ./log/development.log; \
	else \
		echo "Server was not running in background."; \
	fi

# Installs dependencies, sets right Ruby version
set_rails:
	bundle install
	yarn install --check-files
	rails db:environment:set RAILS_ENV=development

# Executes migrations, resets database, cleans assets and compiles webpacker
rails_tasks: set_rails
	rails db:migrate:reset db:drop db:reset #assets:clobber assets:precompile
