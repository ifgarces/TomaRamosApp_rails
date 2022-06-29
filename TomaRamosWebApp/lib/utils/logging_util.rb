require "logger"

# Simple interface for initializing loggers with a custom format for this application.

module LoggingUtil
  public

  # @param label [String] Label for tracing logging scope. Can be the file path in which the method
  # is called from.
  # @param level [Integer] Log level.
  # @return [Logger]
  def self.getStdoutLogger(label, level = Logger::DEBUG)
    callerFilename = File.basename(label)
    logger = Logger.new(STDOUT)
    logger.level = level
    logger.formatter = proc do |severity, datetime, progname, msg|
      dateFormat = datetime.strftime("%Y-%m-%d %H:%M:%S")
      "[%s][%s][#%d][%s] %s\n" % [
        dateFormat, callerFilename, Process.pid, severity, msg
      ]
    end
    return logger
  end
end
