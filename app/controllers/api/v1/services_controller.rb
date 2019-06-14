class Api::V1::ServicesController < Api::V1::BaseApiController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /api/v1/services
  def index
    @services  = Salon.find(params[:salon_id]).services
    render 'api/v1/sevices/index.json.jbuilder'
  end

  # GET /api/v1/services/1
  def show
    @promotion_price =  @service.price_cents *  (@service.promotion.percentage / 100)
    @promotion_percentage = @service.promotion.percentage
    render 'api/v1/services/show.json.jbuilder'

  end

  # POST /api/v1/services
  def create
    @service = Service.new(service_params)

    respond_to do |format|
      if @service.save
        format.json { render :show, status: :created, location: @service }
      else
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/services/1
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.json { render :show, status: :ok, location: @service }
      else
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/services/1
  def destroy
    @service.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = Service.find(params[:id])
    end

    # Only allow the white list through.
    def service_params
      params.fetch(:service, {})
    end
end

