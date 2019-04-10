class AppointmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :new, :show]
    require 'rest-client'
    require 'json'
  def index
    @appointments = policy_scope(Appointment)
  end

  def new
    @appointment = Appointment.new
    authorize @appointment
  end

  def show
    @appointment = Appointment.find(params[:id])
    if (mobile_device? ==='mobile')
      render "show_mobile"
  end
    authorize @appointment
  end

  def create
    appointment = Appointment.new
    appointment.start_appointment = params[:appointment][:start_date_time]
    # TODO => add service duration
    appointment.end_appointment = params[:appointment][:start_date_time]
    appointment.customer_id = current_user.id
    appointment.status = Appointment::EN_COURS
    appointment.service_id = params[:service_id]
    authorize appointment

    if appointment.save
      tel= appointment.customer.phone_number
      tel= '+221'+''+tel.split(' ')[1] 
      tel= tel.split('-')[0]+''+tel.split('-')[1]+''+tel.split('-')[2]+''+tel.split('-')[3]   
      response =  RestClient.post('https://api.orange.com/oauth/v2/token',
      {"grant_type":"client_credentials"},
       {:Authorization => 'Basic WkNiUXpRT2JZTTBxV2ltMURsSzBtTnVqQXltMXhLUUM6bWhjRHVtRldHMWF6ZjFpaQ==',
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    reponse=JSON.parse(response)
    token = reponse["access_token"]
    tel_institut = appointment.service.salon.phone_number.split('-')[1]
    dateRDV = l(appointment.start_appointment,format: :short)
    serviceName = appointment.service.name 
    salonName = appointment.service.salon.name
    salonAdress = appointment.service.salon.address
    smsResponse = RestClient.post "https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B221783848922/requests", 
    {"outboundSMSMessageRequest": {"address": "tel:"+""+tel,"senderAddress": "tel:+221783848922","senderName": "Elmadeal", "outboundSMSTextMessage": 
    {"message": "Votre Rendez-vous "+serviceName+" à l'institut "+salonName+" "+salonAdress+" "+tel_institut+" est confirmé pour le "+dateRDV+". Merci pour la confiance."}
    } 
  }.to_json,
    { content_type: :json, accept: :json, :Authorization => 'Bearer'+' '+token}
    logger.info "--->3 ✅ RDV-SMS: #{smsResponse}"
      redirect_to appointment_path(appointment)
    else
      flash[:error] = "Appointment unsuccessful #{appointment.errors}"
    end
  end

  def create_without_redirect( service_id,start_appointment,user_id)
    logger.info "--->3 ✅ service_id: #{service_id}"

    appointment = Appointment.new
    appointment.start_appointment = start_appointment
    # TODO => add service duration
    appointment.end_appointment = start_appointment
    appointment.customer_id = user_id
    appointment.status = Appointment::EN_COURS
    appointment.service_id = service_id.to_i
    appointment.save
    tel= appointment.customer.phone_number
      tel= '+221'+''+tel.split(' ')[1] 
      tel= tel.split('-')[0]+''+tel.split('-')[1]+''+tel.split('-')[2]+''+tel.split('-')[3]   
      response =  RestClient.post('https://api.orange.com/oauth/v2/token',
      {"grant_type":"client_credentials"},
       {:Authorization => 'Basic WkNiUXpRT2JZTTBxV2ltMURsSzBtTnVqQXltMXhLUUM6bWhjRHVtRldHMWF6ZjFpaQ==',
      'Content-Type': 'application/x-www-form-urlencoded'
    })
    reponse=JSON.parse(response)
    token = reponse["access_token"]
    tel_institut = appointment.service.salon.phone_number.split('-')[1]
    dateRDV = l(appointment.start_appointment,format: :short)
    serviceName = appointment.service.name 
    salonName = appointment.service.salon.name
    salonAdress = appointment.service.salon.address
    smsResponse = RestClient.post "https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B221783848922/requests", 
    {"outboundSMSMessageRequest": {"address": "tel:"+""+tel,"senderAddress": "tel:+221783848922","senderName": "Elmadeal", "outboundSMSTextMessage": 
    {"message": "Votre Rendez-vous "+serviceName+" à l'institut "+salonName+" "+salonAdress+" "+tel_institut+" est confirmé pour le "+dateRDV+". Merci pour la confiance."}
    } 
  }.to_json,
    { content_type: :json, accept: :json, :Authorization => 'Bearer'+' '+token}
    logger.info "--->3 ✅ RDV-SMS: #{smsResponse}"
    logger.info "--->3 ✅ appointment.save: #{appointment.to_json}"
    logger.info "--->3 ✅ appointment.errors: #{appointment.errors.to_json}"

    if appointment.valid?
      logger.info "--->3 ✅ appointment.save: #{appointment.to_json}"
      appointment.id
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:start_date_time, :user_id, :service_id )
  end
end