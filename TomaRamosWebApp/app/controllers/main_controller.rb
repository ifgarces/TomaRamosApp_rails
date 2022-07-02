require "utils/logging_util"

class MainController < ApplicationController
  before_action :getUser
  before_action :updateUserLastActivity

  def initialize()
    super
    @log = LoggingUtil.newStdoutLogger(__FILE__)
  end

  def getUser()
    @currentUser = self.getUserFromSession()
  end

  def updateUserLastActivity()
    @currentUser.updateLastActivity()
  end

  def home()
    redirect_to("/courses") #* temporally disabling this view
    # render :home
  end

  def courses()
    render :courses
  end

  def schedule()
    render :schedule
  end

  def evaluations()
    render :evaluations
  end

  # Inscribes a course in `session` given a `courseId`
  # @return [nil]
  def inscribeCourse()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse.nil?)
      @log.error("Cannot inscribe course ID '#{params[:courseId]}': invalid ID")
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido"
      )
    end

    @currentUser.inscribeNewCourse(targetCourse)

    redirect_to(
      "/courses",
      notice: "%s (NRC %s) inscrito" % [targetCourse.title, targetCourse.nrc]
    )
  end

  # @return [nil]
  def debugClearSession()
    session[:guestUserId] = nil
    @currentUser = nil

    # Refreshing current page for changes to be reflected immediately
    redirect_to(
      request.path,
      notice: "[debug] Session cleared"
    )
  end

  private
  # @return [User] The stored user from the `session` (creates it if needed)
  def getUserFromSession()
    guestUserId = session[:guestUserId]
    if (guestUserId.nil? || (User.find_by(id: guestUserId).nil?))
      guestUser = User.createNewGuestUser()
      guestUser.save!()
      session[:guestUserId] = guestUser.id

      Rails.logger.info("New guest User created: '#{guestUser.username}'")
    else
      guestUser = User.find_by(id: guestUserId)
    end

    return guestUser
  end
end
