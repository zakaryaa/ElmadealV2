class Api::V1::PromotionsController < Api::V1::BaseApiController
  def index
    @promotions = Service.find(params[:service_id]).promotions
     render 'api/v1/promotions/index.json.jbuilder'

  end
  def show
    @Promotion = Promotion.find(params[:id])
    render 'api/v1/promotions/show.json.jbuilder'
  end

end
