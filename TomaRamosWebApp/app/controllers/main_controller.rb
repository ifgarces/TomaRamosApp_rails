class MainController < ApplicationController
  def home
    render :home
  end

  def courses
    render :courses
  end

  def schedule
    render :schedule
  end

  def evaluations
    render :evaluations
  end
end
