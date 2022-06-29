require "logger"

# Simple interface for initializing loggers with a custom format for this application.

module LoggingUtil
  public

  # @param customLabel [String] Can be a path `__FILE__` of the file in which the method is called
  # from.
  # @param logLevel [Integer]
  # @return [Logger]
  def self.getStdoutLogger(customLabel, logLevel = Logger::DEBUG)
    callerFilename = File.basename(customLabel)
    logger = Logger.new(STDOUT)
    logger.level = logLevel
    logger.formatter = proc do |severity, datetime, progname, msg|
      dateFormat = datetime.strftime("%Y-%m-%d %H:%M:%S")
      "[%s][%s][#%d][%s] %s\n" % [
        dateFormat, callerFilename, Process.pid, severity, msg
      ]
    end
    return logger
  end
end
