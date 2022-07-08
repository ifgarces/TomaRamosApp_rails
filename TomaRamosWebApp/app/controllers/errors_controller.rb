class ErrorsController < ApplicationController
  def not_found
    render :not_found, status: 404
  end

  def server_error
    render :server_error, status: 500
  end
end
