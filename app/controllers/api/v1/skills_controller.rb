class Api::V1::SkillsController < Api::V1::BaseApiController

  # GET /api/v1/services
  def index
    render json: ServiceSerializer.new(Skill.find(params[:salon_id]).services).serialized_json
  end

end
