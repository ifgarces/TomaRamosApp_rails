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
    @currentUser = self.getUserFromSession()
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

  # @return [nil]
  def conflict_dialog()
    # @log.info(">>> #{params[:hello]}")
    @hello = params[:hello]
    @log.debug(">>> hello=#{@hello}")
    render :conflict_dialog
  end

  # Inscribes a course in `session` given a `courseId`, checking for conflicts with the current
  # inscribed events first.
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

    if (isAlreadyInscribed)
      redirect_to(
        course_instances_url,
        alert: "El ramo NRC #{targetCourse.nrc} ya está inscrito"
      )
    end

    conflicts = @currentUser.getConflictsForNewCourse(targetCourse)

    if (conflicts.count() == 0)
      self.inscribeCourseAction(targetCourse)
    else
      @conflicts = conflicts
      @targetCourse = targetCourse
      redirect_to(
        :conflict_dialog => { hello: "world" }
      )
    end
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

  private

  # Intended to be called from `inscribe_course_safe` when succeeded.
  # @return [nil]
  def inscribeCourseAction(targetCourse)
    @currentUser.inscribeNewCourse(targetCourse)
    redirect_to(
      :courses,
      notice: "%s (NRC %s) inscrito" % [targetCourse.title, targetCourse.nrc]
    )
  end

  # @return [User] The stored user from the `session`, creating it if needed.
  def getUserFromSession()
    guestUserId = session[:guestUserId]

    if ((guestUserId == nil) || (User.find_by(id: guestUserId) == nil))
      guestUser = User.createNewGuestUser()
      guestUser.save!()
      session[:guestUserId] = guestUser.id
      @log.info("New guest User created: '#{guestUser.username}'")
    else
      guestUser = User.find_by(id: guestUserId)
    end

    return guestUser
  end
end
