class Api::V1::RolesController < Api::V1::BaseApiController
  def index
    @roles = Salon.find(params[:salon_id]).roles
    render 'api/v1/roles/index.json.jbuilder'
  end

  def show
    @role = Role.find(params[:id])
    render 'api/v1/roles/show.json.jbuilder'
  end
end
