# Simple interface for initializing loggers with a custom format for this application.

module LoggingUtil
  def self.getStdoutLogger(logLevel = Logger::DEBUG)
    logger = Logger.new(STDOUT)
    logger.level = logLevel
    logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      "[#{date_format}][##{Process.pid}][#{severity}] #{msg}\n"
    end
    return logger
  end
end
