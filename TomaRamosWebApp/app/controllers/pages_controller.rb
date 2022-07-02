class PagesController < ApplicationController
  def home()
    render :home
  end

  def about()
    render :about
  end

  def not_found()
    render :not_found
  end

  def awesome()
    render :awesome
  end
end
