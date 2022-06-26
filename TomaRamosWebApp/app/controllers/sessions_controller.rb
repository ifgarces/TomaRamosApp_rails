class SessionsController < ApplicationController
  def new()
    render :new
  end

  def create()
    user_info = request.env["omniauth.auth"]
    puts(">>> omniauth.auth: #{user_info}")
    puts(">>> request: #{request}")
    raise NotImplementedError.new("Handle session")
    raise user_info # Your own session management should be placed here.
  end
end
