require "utils/logging_util"

class ApplicationController < ActionController::Base
  # Ensuring the exception is logged, with backtrace, as we are using a custom error page which
  # somehow prevents Rails from properly logging the error (apparently?)
  rescue_from Exception do |e|
    log = LoggingUtil.getStdoutLogger(__FILE__)

    log.error("<<< Exception start >>>")

    session[:errorDataToUser] = e.class

    log.error("Host: #{request.remote_addr}")
    log.error("Exception class: #{e.class}")
    log.error("Exception summary: #{e}")
    log.error("Backtrace:\n#{e.backtrace.join("\n")}")
    log.error("<<< End of exception >>>")
    render status: 500
  end
end
