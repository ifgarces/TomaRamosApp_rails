class RamoEventsController < ApplicationController
  before_action :set_ramo_event, only: %i[ show edit update destroy ]

  # GET /ramo_events or /ramo_events.json
  def index
    @ramo_events = RamoEvent.all
  end

  # GET /ramo_events/1 or /ramo_events/1.json
  def show
  end

  # GET /ramo_events/new
  def new
    @ramo_event = RamoEvent.new
  end

  # GET /ramo_events/1/edit
  def edit
  end

  # POST /ramo_events or /ramo_events.json
  def create
    @ramo_event = RamoEvent.new(ramo_event_params)

    respond_to do |format|
      if @ramo_event.save
        format.html { redirect_to ramo_event_url(@ramo_event), notice: "Ramo event was successfully created." }
        format.json { render :show, status: :created, location: @ramo_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ramo_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ramo_events/1 or /ramo_events/1.json
  def update
    respond_to do |format|
      if @ramo_event.update(ramo_event_params)
        format.html { redirect_to ramo_event_url(@ramo_event), notice: "Ramo event was successfully updated." }
        format.json { render :show, status: :ok, location: @ramo_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ramo_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ramo_events/1 or /ramo_events/1.json
  def destroy
    @ramo_event.destroy

    respond_to do |format|
      format.html { redirect_to ramo_events_url, notice: "Ramo event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ramo_event
      @ramo_event = RamoEvent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ramo_event_params
      params.require(:ramo_event).permit(:location, :day_of_week, :start_time, :end_time, :date)
    end
end
