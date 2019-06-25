class Api::V1::PhotosController < Api::V1::BaseApiController
  def index
  @photos = Salon.find(params[:salon_id]).photos
    render 'api/v1/photos/index.json.jbuilder'
  end
  def show
    @photo = Photo.find(params[:id])
  end
end
