require "utils/logging_util"

class AcademicPeriodsController < ApplicationController
  before_action :set_academic_period, only: %i[ show edit update destroy ]
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

  # GET /academic_periods or /academic_periods.json
  def index
    @academic_periods = AcademicPeriod.all
  end

  # GET /academic_periods/1 or /academic_periods/1.json
  def show
  end

  # GET /academic_periods/new
  def new
    @academic_period = AcademicPeriod.new
  end

  # GET /academic_periods/1/edit
  def edit
  end

  # POST /academic_periods or /academic_periods.json
  def create
    @academic_period = AcademicPeriod.new(academic_period_params)

    respond_to do |format|
      if @academic_period.save
        format.html { redirect_to academic_period_url(@academic_period), notice: "Academic period was successfully created." }
        format.json { render :show, status: :created, location: @academic_period }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @academic_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /academic_periods/1 or /academic_periods/1.json
  def update
    respond_to do |format|
      if @academic_period.update(academic_period_params)
        format.html { redirect_to academic_period_url(@academic_period), notice: "Academic period was successfully updated." }
        format.json { render :show, status: :ok, location: @academic_period }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @academic_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /academic_periods/1 or /academic_periods/1.json
  def destroy
    @academic_period.destroy

    respond_to do |format|
      format.html { redirect_to academic_periods_url, notice: "Academic period was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academic_period
      @academic_period = AcademicPeriod.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def academic_period_params
      params.require(:academic_period).permit(:name)
    end
end
