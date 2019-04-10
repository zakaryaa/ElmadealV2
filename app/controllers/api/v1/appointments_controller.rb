class Api::V1::AppointmentsController < Api::V1::BaseApiController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  before_action :set_customer, only: [:create,:update]

  # GET /api/v1/salons/2/appointments
  def index
    render json: AppointmentSerializer.new(Salon.find(params[:salon_id]).appointments).serialized_json
  end

  # GET /api/v1/salons/2/appointments/2
  def show
    render json: AppointmentSerializer.new(@appointment).serialized_json
  end

  # POST /api/v1/salons/2/appointment
  def create
    @appointment = Appointment.new(
      appointment_params.merge!(
        customer_id: @set_customer.id,
        end_appointment: get_appointment_end_date(appointment_params[:start_appointment],appointment_params[:service_id]),
      )
    )

    if @appointment.save && !@set_customer.nil?
      show
    else
      render json: {errors: @appointment.errors, status: :unprocessable_entity }
    end

  end

  # PATCH/PUT /api/v1/salons/2/appointments/1
  def update
    if @appointment.update(
        appointment_params.merge!(
          customer_id: @set_customer.id,
          service_category: Service.find(appointment_params[:service_id].to_i).category,
          end_appointment: get_appointment_end_date(appointment_params[:start_appointment],appointment_params[:service_id])
        )) && !@set_customer.nil?
      show
    else
      render json: {errors: @appointment.errors, status: :unprocessable_entity }
    end

  end

  # DELETE /api/v1/salons/1/appointments/3
  def destroy
    entity = AppointmentSerializer.new(@appointment).serialized_json
    if @appointment.destroy
      render json: entity
    else
      render json: {errors: @appointment.errors, status: :unprocessable_entity }
    end
  end

  private

  def customer?
    return Role.where(user_id: @set_customer.id, salon_id: params[:salon_id]).count > 0
  end

  def get_appointment_end_date(start_date,service_id)
    start_date.to_time + Service.find(service_id).duration.to_i.minutes
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def set_customer
    @set_customer = User.find_by(phone_number: customer_params[:phone_number])
    if @set_customer.nil? && !customer_params[:email].empty?
      @set_customer = User.find_by(email: customer_params[:email])
    end

    if @set_customer.nil?
      @set_customer = User.new(customer_params.merge!(password: "123456"))
      if @set_customer.save
        unless customer?
          Role.create(role: Role::CUSTOMER, user_id: @set_customer.id,salon_id: params[:salon_id])
        end
      else
        render json: {errors: @set_customer.errors, status: :unprocessable_entity }
      end
    else
      @set_customer.update(customer_params)
      unless customer?
        Role.create(role: Role::CUSTOMER, user_id: @set_customer.id,salon_id: params[:salon_id])
      end
    end

  end

  # Only allow the white list through.
  def customer_params
    params.fetch(:customer, {})
    .permit(:user_id,:phone_number,:first_name,:last_name,:email,:address,:city)
  end

  def appointment_params
    params.fetch(:appointment, {})
    .permit(:start_appointment,:service_id,:customer_id,:status,:end_appointment,:employee_id)
  end
end
