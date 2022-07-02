require "utils/logging_util"

class MainController < ApplicationController
  before_action :initLog
  before_action :initCurrentUser
  before_action :updateUserLastActivity

  # @return [nil]
  def initLog()
    @log = LoggingUtil.newStdoutLogger(__FILE__)
  end

  # @return [nil]
  def initCurrentUser()
    @currentUser = helpers.getUserFromSession()
  end

  # @return [nil]
  def updateUserLastActivity()
    @currentUser.updateLastActivity()
  end

  # @return [nil]
  def home()
    redirect_to(:courses) #* temporally disabling this view
    #// render :home
  end

  # @return [nil]
  def courses()
    render :courses
  end

  # @return [nil]
  def schedule()
    render :schedule
  end

  # @return [nil]
  def evaluations()
    render :evaluations
  end

  # Inscribes a course in `session` given a `courseId`. Assumes the user was properly noticed of
  # possible conflicts with their currently inscribed courses.
  # @return [nil]
  def inscribe_course_safe()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse.nil?)
      @log.error("Cannot inscribe course ID '#{params[:courseId]}': invalid ID")
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido"
      )
    end

    isAlreadyInscribed = @currentUser.getInscribedCourses().map { |course|
      course.id
    }.include?(targetCourse.id)

    if (@currentUser.isCourseAlreadyInscribed(targetCourse))
      redirect_to(
        course_instances_url,
        alert: "El ramo NRC #{targetCourse.nrc} ya está inscrito"
      )
    end

    @currentUser.inscribeNewCourse(targetCourse)

    redirect_to(
      :courses,
      notice: "%s (NRC %s) inscrito" % [targetCourse.title, targetCourse.nrc]
    )
  end

  # @return [nil]
  def uninscribeAllCourses()
    userCourses = @currentUser.getInscribedCourses()
    count = userCourses.count()
    userCourses.each do |course|
      @currentUser.uninscribeCourse(course)
    end

    redirect_to(
      :courses,
      notice: "#{count} cursos des-inscritos"
    )
  end

  # @return [nil]
  def debugClearSession()
    @currentUser.destroy!() #! deleting guest user
    session[:guestUserId] = nil
    @currentUser = nil

    # Refreshing current page for changes to be reflected immediately
    redirect_to(
      request.path, #? <- is this a bad practice? should be fine for `href` (GET) buttons, right?
      notice: "[debug] Session cleared"
    )
  end
end
