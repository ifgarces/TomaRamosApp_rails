require "utils/logging_util"
require "enums/career_enum"

class CourseInstancesController < ApplicationController
  before_action :set_course_instance, only: %i[ show edit update destroy ]
  before_action :abortAndRedirect, only: %i[ new edit create update destroy ]

  def initialize()
    super
    @log = LoggingUtil.newStdoutLogger(__FILE__)
  end

  # For disabling some operations on this controller (temporal workaround)
  # @return [nil]
  def abortAndRedirect()
    @log.warn("abortAndRedirect for CUD request: #{request.path}")
    redirect_to(root_path)
  end

  # GET /course_instances or /course_instances.json
  def index
    @targetAcademicPeriod = AcademicPeriod.getLatest()
    @course_instances = @targetAcademicPeriod.getCourses()
    render :index
  end

  # GET /course_instances/1 or /course_instances/1.json
  def show
    render :show
  end

  # GET /course_instances/new
  def new
    @course_instance = CourseInstance.new
  end

  # GET /course_instances/1/edit
  def edit
    render :edit
  end

  # POST /course_instances or /course_instances.json
  def create
    @course_instance = CourseInstance.new(course_instance_params)

    respond_to do |format|
      if @course_instance.save
        format.html { redirect_to course_instance_url(@course_instance), notice: "Course instance was successfully created." }
        format.json { render :show, status: :created, location: @course_instance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_instances/1 or /course_instances/1.json
  def update
    respond_to do |format|
      if @course_instance.update(course_instance_params)
        format.html { redirect_to course_instance_url(@course_instance), notice: "Course instance was successfully updated." }
        format.json { render :show, status: :ok, location: @course_instance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_instances/1 or /course_instances/1.json
  def destroy
    @course_instance.destroy

    respond_to do |format|
      format.html { redirect_to course_instances_url, notice: "Course instance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_instance
      @course_instance = CourseInstance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_instance_params
      params.require(:course_instance).permit(
        :nrc, :title, :teacher, :credits, :career, :course_number, :section, :curriculum, :liga,
        :lcruz
      )
    end
end
