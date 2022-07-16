require "utils/logging_util"

class ApplicationController < ActionController::Base
  # Ensuring the exception is logged, with backtrace, as we are using a custom error page which
  # somehow prevents Rails from properly logging the error (apparently?)
  rescue_from Exception do |err|
    [ #? is this working as expected?
      LoggingUtil.getStdoutLogger(__FILE__),
      LoggingUtil.getErrorLogger(__FILE__)
    ].each do |log|
      log.error("<<< Exception begin >>>")
      log.error("Host: #{request.remote_addr}")
      log.error("Exception class: #{err.class}")
      log.error("Exception summary: #{err}")
      log.error("Backtrace:\n#{err.backtrace.join("\n")}")
      log.error("<<< Exception end >>>")
    end

    # Briefly using `session` for displaying minimal error information to the user
    session[:displayableErrorInfo] = err.class

    render status: 500
  end
end
