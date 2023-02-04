ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Reading environment variables required for parsing database.yml
# require "dotenv"
# Dotenv.load(File.join("..", ".env"), File.join("..", ".secrets.env"))

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
