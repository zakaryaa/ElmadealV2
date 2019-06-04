class Api::V1::SalonsController < Api::V1::BaseApiController
   before_action :set_salon, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/salons
  def index
    @salons = Salon.all
     render 'api/v1/index.json.jbuilder'
  end

  # GET /api/v1/salons/1
  def show

  end

  # POST /api/v1/salons
  def create
    @salon = Salon.new(salon_params)

    if @salon.save
      show
    else
      render json: {errors: @salon.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /api/v1/salons/1
  def update
    if Salon.update(salon_params)
      show
    else
      render json: {errors: @salon.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /api/v1/salons/1
  def destroy
    entity = SalonSerializer.new(@salon).serialized_json
    if @salon.destroy
      render json: entity
    else
      render json: {errors: @salon.errors, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_salon
      @salon = Salon.find(params[:id])
    end

    # Only allow the white list through.
    def salon_params
      params.fetch(:salon, {}).permit(:id,:name,:description,:address,:city,:phone_number)
    end

end
