require "logger"

# Simple interface for initializing loggers with a custom format for this application.

module LoggingUtil
  public

  # @param output [String | IO] A filename or stream to log to.
  # @param label [String] Label for tracing logging scope. Can be the file path in which the method
  # is called from.
  # @param level [Integer] Log level.
  # @return [Logger]
  def self.getStdoutLogger(label, level = Logger::DEBUG)
    if (@@logsHash.keys.include?(label))
      return @@logsHash[label]
    end
    newLogger = self.createNewLogger(output: STDOUT, label: label, level: level)
    @@logsHash[label] = newLogger
    return newLogger
  end

  private

  # Mapping labels with loggers to avoid creating a new one every time `getStdoutLogger` is called.
  @@logsHash = {} # :Hash<String, Logger>

  # @param output [String | IO] A filename or stream to log to.
  # @param label [String] Label for tracing logging scope. Can be the file path in which the method
  # is called from.
  # @param level [Integer] Log level.
  # @return [Logger]
  def self.createNewLogger(output:, label:, level:)
    callerFilename = File.basename(label)
    logger = Logger.new(output)
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
