class CourseEventsController < ApplicationController
  before_action :set_course_event, only: %i[ show edit update destroy ]
  before_action :abortAndRedirect, only: %i[ index show new edit create update destroy ]

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

  # GET /course_events or /course_events.json
  def index
    @course_events = CourseEvent.all
  end

  # GET /course_events/1 or /course_events/1.json
  def show
  end

  # GET /course_events/new
  def new
    @course_event = CourseEvent.new
  end

  # GET /course_events/1/edit
  def edit
  end

  # POST /course_events or /course_events.json
  def create
    @course_event = CourseEvent.new(course_event_params)

    respond_to do |format|
      if @course_event.save
        format.html { redirect_to course_event_url(@course_event), notice: "Course event was successfully created." }
        format.json { render :show, status: :created, location: @course_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /course_events/1 or /course_events/1.json
  def update
    respond_to do |format|
      if @course_event.update(course_event_params)
        format.html { redirect_to course_event_url(@course_event), notice: "Course event was successfully updated." }
        format.json { render :show, status: :ok, location: @course_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /course_events/1 or /course_events/1.json
  def destroy
    @course_event.destroy

    respond_to do |format|
      format.html { redirect_to course_events_url, notice: "Course event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course_event
      @course_event = CourseEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_event_params
      params.require(:course_event).permit(:location, :day_of_week, :start_time, :end_time, :date)
    end
end
