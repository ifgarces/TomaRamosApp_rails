require "utils/logging_util"

class MainController < ApplicationController
  def initialize()
    super
    @log = LoggingUtil.newStdoutLogger(__FILE__)

    @guestUser = getUserFromSession()
  end

  def home()
    render :home
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

    if (session[:inscribedCourses].nil?)
      session[:inscribedCourses] = [] # :Array<Integer>
    end
    session[:inscribedCourses].append(targetCourse.id)
    redirect_to(
      course_instances_url,
      notice: "%s (NRC %s) inscrito" % [targetCourse.title, targetCourse.nrc]
    )
  end

  # @return [nil]
  def clearInscribedCourses()
    if (session[:inscribedCourses].nil?)
      return
    end
    count = session[:inscribedCourses].count()
    session.delete(:inscribedCourses)
    redirect_to(
      "/courses",
      notice: "%d cursos des-inscritos" % [count]
    )
  end
end
