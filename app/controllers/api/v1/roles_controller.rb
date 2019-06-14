class Api::V1::RolesController < Api::V1::BaseApiController
  def index
    @roles = salon.find(params[:salon_id]).roles
    render 'api/v1/roles/index.json.jbuilder'
  end
  def show
    @Role = Role.find(params[:id])
    render 'api/v1/roles/index.json.jbuilder'
  end
end
