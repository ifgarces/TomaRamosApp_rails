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

  def inscribe_course()
    targetCourse = CourseInstance.find_by(id: params[:courseId])
    if (targetCourse == nil)
      redirect_to(
        course_instances_url,
        alert: "Error: ramo inválido"
      )
    end
    if (session[:inscribedCourses].nil?)
      session[:inscribedCourses] = []
    end
    session[:inscribedCourses].append(targetCourse)
    redirect_to(
      course_instances_url,
      notice: "%s (NRC %s) inscrito" % [targetCourse.title, targetCourse.nrc]
    )
  end
end
