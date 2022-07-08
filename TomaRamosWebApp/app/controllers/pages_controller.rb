require "utils/logging_util"

class PagesController < ApplicationController
  def home()
    render :home
  end

  def about()
    render :about
  end

  def awesome()
    render :awesome
  end
end
