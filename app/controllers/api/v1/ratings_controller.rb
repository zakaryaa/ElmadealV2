class Api::V1::RatingsController < Api::V1::BaseApiController
  def index
    @ratings = rating.find(params[:customer_id]).ratings
    render 'api/v1/ratings/index.json.jbuilder'
  end
  def show
    @Rating = Rating.find(params[:id])
    render 'api/v1/ratings/index.json.jbuilder'


  end
  def create
    @rating = Rating.create(user_id: current_user.id)
  end
end

