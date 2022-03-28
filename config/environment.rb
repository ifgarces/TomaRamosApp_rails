# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Configuring logger
Rails.logger.level = Logger::DEBUG
Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"
#Rails.logger = ActiveSupport::Logger.new("log/#{Rails.env}.log")
Rails.logger = Logger.new(STDOUT)
