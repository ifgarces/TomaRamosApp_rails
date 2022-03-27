class AppMetadataController < ApplicationController
  before_action :set_app_metadatum, only: %i[ show edit update destroy ]

  # GET /app_metadata or /app_metadata.json
  def index
    @app_metadata = AppMetadatum.all
  end

  # GET /app_metadata/1 or /app_metadata/1.json
  def show
  end

  # GET /app_metadata/new
  def new
    @app_metadatum = AppMetadatum.new
  end

  # GET /app_metadata/1/edit
  def edit
  end

  # POST /app_metadata or /app_metadata.json
  def create
    @app_metadatum = AppMetadatum.new(app_metadatum_params)

    respond_to do |format|
      if @app_metadatum.save
        format.html { redirect_to app_metadatum_url(@app_metadatum), notice: "App metadatum was successfully created." }
        format.json { render :show, status: :created, location: @app_metadatum }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @app_metadatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /app_metadata/1 or /app_metadata/1.json
  def update
    respond_to do |format|
      if @app_metadatum.update(app_metadatum_params)
        format.html { redirect_to app_metadatum_url(@app_metadatum), notice: "App metadatum was successfully updated." }
        format.json { render :show, status: :ok, location: @app_metadatum }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @app_metadatum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /app_metadata/1 or /app_metadata/1.json
  def destroy
    @app_metadatum.destroy

    respond_to do |format|
      format.html { redirect_to app_metadata_url, notice: "App metadatum was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_app_metadatum
      @app_metadatum = AppMetadatum.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def app_metadatum_params
      params.require(:app_metadatum).permit(:latest_version_name, :catalog_current_period, :catalog_last_updated)
    end
end
