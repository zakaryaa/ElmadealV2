class Api::V1::OpeningHoursController < Api::V1::BaseApiController
  def index
    @opening_hours = Salon.find(params[:salon_id]).opening_hours

    render 'api/v1/opening_hours/index.json.jbuilder'

  end
  def show
    @Opening_hour =OpeningHour.find(params[:id])

  end
end
