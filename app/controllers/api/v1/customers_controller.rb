class Api::V1::CustomersController < Api::V1::BaseApiController

  # GET /api/v1/customers
  def index
    customers = User.where( id: Role.where( salon_id: params[:salon_id],
                                            user_id: Salon.find(params[:salon_id]).users.pluck(:id),
                                            role: Role::CUSTOMER)
                                    .pluck(:user_id)
                          )

    render json: UserSerializer.new(customers).serialized_json
  end

  # POST /api/v1/customers
  def create
    @customer= User.new(customer_params)
    if @customer.save
      render json: UserSerializer.new(@customer).serialized_json
    else
      render json: {errors: @customer.errors, status: :unprocessable_entity }
    end
  end

  private

    # Only allow the white list through.
    def customer_params
      params.fetch(:customer, {}).permit(:user_id,:phone_number,:first_name,:last_name,:email,:address,:city,:role)
    end
end
