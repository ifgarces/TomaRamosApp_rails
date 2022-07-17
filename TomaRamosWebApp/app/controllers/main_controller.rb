require "tempfile"
require "utils/logging_util"
require "enums/day_of_week_enum"
require "events_logic/week_schedule"

class MainController < ApplicationController
  before_action :initLog
  before_action :initCurrentUser
  before_action :updateUserLastActivity

  # @return [nil]
  def initLog()
    @log = LoggingUtil.getStdoutLogger(__FILE__)
    @inDebugMode = helpers.isRequestLocal()
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
    courses = @currentUser.getInscribedCourses()
    if ((courses.nil?) || (courses.count() == 0))
      redirect_to(
        :courses,
        alert: "Primero debe inscribir al menos un ramo"
      )
      return
    end
    @weekScheduleData = WeekSchedule.computeWeekScheduleBlocks(courses)

    render :schedule
  end

  # @return [nil]
  def evaluations()
    render :evaluations
  end

  # Inscribes a course in `session` given a `courseId`. Assumes the user was properly noticed of
  # possible conflicts with their currently inscribed courses.
  # @return [nil]
  def inscribeCourse()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse.nil?)
      @log.error("Cannot inscribe course ID '#{params[:courseId]}': invalid ID")
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido"
      )
      return
    end

    isAlreadyInscribed = @currentUser.getInscribedCourses().map { |course|
      course.id
    }.include?(targetCourse.id)

    if (@currentUser.isCourseAlreadyInscribed(targetCourse))
      redirect_to(
        :courses,
        alert: "El ramo NRC #{targetCourse.nrc} ya está inscrito"
      )
      return
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

  def downloadSchedule()
    raise NotImplementedError.new()

    scheduleTableRawHTML = render_to_string(
      partial: "main/week_schedule_table",
      locals: {
        #weekScheduleData: @weekScheduleData
        weekScheduleData: WeekSchedule.computeWeekScheduleBlocks(@currentUser.getInscribedCourses())
      },
      width: 1000,
      height: 700
    )

    imgKit = IMGKit.new(scheduleTableRawHTML)#, quality: 50, width: 1000)
    imgKit.stylesheets.append("#{Rails.root}/app/assets/stylesheets/application.bootstrap.scss")

    #send_data(imgKit.to_jpg(), type: "image/jpeg", disposition: "inline") # https://stackoverflow.com/a/8295499/12684271

    #resultImage = imgKit.to_img(:jpg)
    resultImage = imgKit.to_png()

    imgTempOutput = Tempfile.new("jpg", encoding: "utf-8", binmode: false)
    resultImage.to_file(imgTempOutput.path)
    #imgTempOutput.rewind()
    imgTempOutput.flush()

    send_file(imgTempOutput.path) # if trouble, place in the `public` directory instead of whatever `TempFile` uses (`/tmp`?)
  end

  # @return [nil]
  def debugClearSession()
    @currentUser.destroy!() #! deleting guest user
    session[:guestUserId] = nil
    @currentUser = nil

    # Refreshing current page for changes to be reflected immediately
    redirect_to(
      :courses,
      notice: "[debug] Session cleared"
    )
  end
end
