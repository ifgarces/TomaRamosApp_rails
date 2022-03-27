class RamosController < ApplicationController
  before_action :set_ramo, only: %i[ show edit update destroy ]

  # GET /ramos or /ramos.json
  def index
    @ramos = Ramo.all
  end

  # GET /ramos/1 or /ramos/1.json
  def show
  end

  # GET /ramos/new
  def new
    @ramo = Ramo.new
  end

  # GET /ramos/1/edit
  def edit
  end

  # POST /ramos or /ramos.json
  def create
    @ramo = Ramo.new(ramo_params)

    respond_to do |format|
      if @ramo.save
        format.html { redirect_to ramo_url(@ramo), notice: "Ramo was successfully created." }
        format.json { render :show, status: :created, location: @ramo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @ramo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ramos/1 or /ramos/1.json
  def update
    respond_to do |format|
      if @ramo.update(ramo_params)
        format.html { redirect_to ramo_url(@ramo), notice: "Ramo was successfully updated." }
        format.json { render :show, status: :ok, location: @ramo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @ramo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ramos/1 or /ramos/1.json
  def destroy
    @ramo.destroy

    respond_to do |format|
      format.html { redirect_to ramos_url, notice: "Ramo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ramo
      @ramo = Ramo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ramo_params
      params.require(:ramo).permit(:name, :profesor, :creditos, :materia, :curso, :seccion, :plan_estudios, :conect_liga, :lista_cruzada)
    end
end
