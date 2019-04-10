class Api::V1::EmployeesController < Api::V1::BaseApiController
  before_action :set_employee, only: [:create]

  # GET /api/v1/employees
  def index
    salon_id = params[:salon_id]
    employees = User.where( id: Role.where(salon_id: params[:salon_id],
                        user_id: Salon.find(params[:salon_id]).users.pluck(:id),
                        role: Role::EMPLOYEE).pluck(:user_id))

    render json: UserSerializer.new(employees).serialized_json
  end

  # POST /api/v1/employees
  def create
    if  @set_employee.nil?
      @set_employee = User.new(employee_params.merge!(password: "123456"))
      if @set_employee.save
        Role.create(role: Role::EMPLOYEE, user_id: @set_employee.id, salon_id: params[:salon_id])
        render json: UserSerializer.new(@set_employee).serialized_json
      else
        render json: {errors: @set_employee.errors, status: :unprocessable_entity }
      end
    else
      @set_employee.update(employee_params)
      unless @set_employee.roles.where(role: Role::EMPLOYEE).count > 0
        Role.create(role: Role::EMPLOYEE, user_id: @set_employee.id, salon_id: params[:salon_id])
      end
      render json: UserSerializer.new(@set_employee).serialized_json
    end
  end

  private

  def set_employee
    @set_employee = User.find_by(phone_number: employee_params[:phone_number])
    if @set_employee.nil? && !employee_params[:phone_number].empty?
      @set_employee = User.find_by(email: employee_params[:email])
    end
  end

    # Only allow the white list through.
    def employee_params
      params.fetch(:employee, {}).permit(:user_id,:phone_number,:first_name,:last_name,:email,:address,:city,:role)
    end
end
