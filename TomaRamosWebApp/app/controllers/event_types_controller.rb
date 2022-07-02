class EventTypesController < ApplicationController
  before_action :set_event_type, only: %i[ show edit update destroy ]
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

  # GET /event_types or /event_types.json
  def index
    @event_types = EventType.all
  end

  # GET /event_types/1 or /event_types/1.json
  def show
  end

  # GET /event_types/new
  def new
    @event_type = EventType.new
  end

  # GET /event_types/1/edit
  def edit
  end

  # POST /event_types or /event_types.json
  def create
    @event_type = EventType.new(event_type_params)

    respond_to do |format|
      if @event_type.save
        format.html { redirect_to event_type_url(@event_type), notice: "Event type was successfully created." }
        format.json { render :show, status: :created, location: @event_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_types/1 or /event_types/1.json
  def update
    respond_to do |format|
      if @event_type.update(event_type_params)
        format.html { redirect_to event_type_url(@event_type), notice: "Event type was successfully updated." }
        format.json { render :show, status: :ok, location: @event_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_types/1 or /event_types/1.json
  def destroy
    @event_type.destroy

    respond_to do |format|
      format.html { redirect_to event_types_url, notice: "Event type was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_type
      @event_type = EventType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_type_params
      params.require(:event_type).permit(:name)
    end
end
