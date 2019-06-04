class Api::V1::SkillsController < Api::V1::BaseApiController
   # GET /api/v1/services
   def index
    @skills = Skill.find(params[:salon_id]).services
    render 'api/v1/index.json.jbuilder'
  end
end
