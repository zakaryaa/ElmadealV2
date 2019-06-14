class Api::V1::SkillsController < Api::V1::BaseApiController
  # GET /api/v1/services
  def index
   @skills = Salon.find(params[:salon_id]).services
   render 'api/v1/skills/index.json.jbuilder'
 end
end
