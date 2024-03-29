require "utils/logging_util"

class SessionsController < ApplicationController
  before_action :initLog

  # @return [nil]
  def initLog()
    @log = LoggingUtil.getStdoutLogger(__FILE__)
  end

  def new()
    raise NotImplementedError.new("This method should not be called")
    render :new
  end

  def create()
    raise NotImplementedError.new("This method should not be called")
    user_info = request.env["omniauth.auth"]
    @log.info(" -------------------- ") #! temp output
    @log.info(">>> omniauth.auth: #{user_info}")
    @log.info(">>> request: #{request}")
    raise NotImplementedError.new("Handle session, get user email and name")
    raise user_info # Your own session management should be placed here.
  end
end
