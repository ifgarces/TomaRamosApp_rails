require "utils/logging_util"

class SessionsController < ApplicationController
  def new()
    render :new
  end

  def create()
    user_info = request.env["omniauth.auth"]
    Rails.logger.info(" -------------------- ") #! temp output
    Rails.logger.info(">>> omniauth.auth: #{user_info}")
    Rails.logger.info(">>> request: #{request}")
    raise NotImplementedError.new("Handle session, get user email and name")
    raise user_info # Your own session management should be placed here.
  end
end
