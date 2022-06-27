class PagesController < ApplicationController
  public

  def home()
    render :home
  end

  def about()
    render :about
  end

  def wip()
    render :wip
  end

  def not_found()
    render :not_found
  end

  def awesome()
    render :awesome
  end
end
