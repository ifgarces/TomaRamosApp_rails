# --------------------------------------------------------------------------------------------------
# Makefile for quickly executing build commands.
# --------------------------------------------------------------------------------------------------

# Setting quiet mode by default (not printing rules when executing them)
ifndef VERBOSE
.SILENT:
endif

PORT = 3030

#* Runs the server in background.
background_server: stop_server set_rails rails_tasks
	rails server --port=${PORT} --binding=localhost -d

# Runs the server, but not in background.
foreground_server: stop_server set_rails rails_tasks
	rails server --port=${PORT} --binding=localhost

hot_restart: stop_server
	rails server --port=${PORT} --binding=localhost -d

# Views server output, when running in background.
output:
	tail -f ./log/development.log -n 30

#* Stops the server, if running at background.
stop_server:
	if [ -f "./tmp/pids/server.pid" ]; then \
		kill $$(cat "./tmp/pids/server.pid"); \
		echo "Server stopped."; \
		rm -f ./log/development.log; \
	else \
		echo "Server was not running in background."; \
	fi

# Installs dependencies, sets right Ruby version.
set_rails:
	rails db:environment:set RAILS_ENV=development
	rvm use 3.0.0@rails6 && rvm current
	bundle install
	yarn install

# Executes migrations, resets database, cleans assets and compiles webpacker.
rails_tasks:
	rails db:migrate:reset assets:clobber assets:precompile
