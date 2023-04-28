require "rest_client"
require "json"
require "utils/logging_util"
require "utils/string_util"
require "enums/day_of_week_enum"
require "events_logic/week_schedule"

class MainController < ApplicationController
  before_action :initLog
  before_action :initCurrentUser
  before_action :updateUserLastActivity

  # @return [nil]
  def initLog()
    @log = LoggingUtil.getStdoutLogger(__FILE__)
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
    if (courses.nil? || (courses.count() == 0))
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
    courses = @currentUser.getInscribedCourses()
    if (courses.nil? || (courses.count() == 0))
      redirect_to(
        :courses,
        alert: "Primero debe inscribir al menos un ramo"
      )
      return
    end

    @course_instances = courses

    render :evaluations
  end

  # Inscribes a course in `session` given a `courseId`. Assumes the user was properly noticed of
  # possible conflicts with their currently inscribed courses.
  #
  # @return [nil]
  def inscribeCourse()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse.nil?)
      @log.error("Cannot inscribe course ID '#{params[:courseId]}': invalid ID")
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido, intente de nuevo"
      )
      return
    end

    if (@currentUser.hasInscribedCourse(targetCourse))
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
  def deinscribeCourse()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse.nil?)
      @log.error("Cannot deinscribe course ID '#{params[:courseId]}': invalid ID")
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido, intente de nuevo"
      )
      return
    end

    targetCourseTitle = targetCourse.title
    targetCourseNrc = targetCourse.nrc
    @currentUser.deinscribeCourse(targetCourse)
    redirect_to(
      :courses,
      notice: "%s (NRC %s) des-inscrito" % [targetCourseTitle, targetCourseNrc]
    )
  end

  # @return [nil]
  def deinscribeAllCourses()
    userCourses = @currentUser.getInscribedCourses()
    count = userCourses.count()
    @currentUser.clearCoursesInscriptions()

    redirect_to(
      :courses,
      notice: "#{count} cursos des-inscritos"
    )
  end

  # @return [nil]
  def downloadSchedule()
    courses = @currentUser.getInscribedCourses()
    if (courses.empty?)
      redirect_to(
        :home,
        alert: "Primero debe inscribir al menos un ramo"
      )
      return
    end

    # Configurable setting for render size with a preset aspect ratio
    aspectRatio = { width: 4, height: 3 }
    scale = 160

    scheduleTableRawHTML = render_to_string(
      partial: "main/week_schedule_table",
      formats: [:html],
      layout: false,
      locals: {
        #weekScheduleData: @weekScheduleData
        weekScheduleData: WeekSchedule.computeWeekScheduleBlocks(courses)
      },
      width: aspectRatio[:width] * scale,
      height: aspectRatio[:height] * scale
    )

    # Consuming html-to-image microservice and sending result to web client (docker-compose runtime
    # only)
    image = RestClient::Request.execute(
      method: :get,
      url: "http://html-to-image:#{ENV.fetch("HTML_TO_IMG_PORT")}",
      payload: JSON.dump({
        html: scheduleTableRawHTML # note: will use CSS styles from bootstrap 5
      }),
      headers: {
        content_type: :json,
        accept: "image/png"
      }
    )
    send_data(image, filename: "horario.png", type: "image/png") # https://stackoverflow.com/a/8295499/12684271
  end
end
