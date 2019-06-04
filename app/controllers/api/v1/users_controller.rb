class Api::V1::UsersController < Api::V1::BaseApiController
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /api/v1/users/1
  def show

  end

  # PATCH/PUT /api/v1/users/1
  def update
    if @user.update(user_params)
      show
    else
      render json: {errors: @user.errors, status: :unprocessable_entity }
    end

  end

  # DELETE /api/v1/users/1
  def destroy
    user = UserSerializer.new(@user).serialized_json
    if Role.where(user_id: @user.id,salon_id: params[:salon_id]).destroy_all
      render json: user
    else
      render json: {errors: @user.errors, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:user_id,:phone_number,:first_name,:last_name,:email,:address,:city,:role)
    end
end
end
