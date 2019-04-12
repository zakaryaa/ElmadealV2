class Users::RegistrationsController < Devise::RegistrationsController
  require 'rest-client'
  require 'json'
  def create
    super
    tel= User.last.phone_number
    tel= '+221'+''+tel.split(' ')[1] 
    tel= tel.split('-')[0]+''+tel.split('-')[1]+''+tel.split('-')[2]+''+tel.split('-')[3]   
    response =  RestClient.post('https://api.orange.com/oauth/v2/token',
    {"grant_type":"client_credentials"},
     {:Authorization => 'Basic WkNiUXpRT2JZTTBxV2ltMURsSzBtTnVqQXltMXhLUUM6bWhjRHVtRldHMWF6ZjFpaQ==',
    'Content-Type': 'application/x-www-form-urlencoded'
  })
  reponse=JSON.parse(response)
  token = reponse["access_token"]
  smsResponse = RestClient.post "https://api.orange.com/smsmessaging/v1/outbound/tel%3A%2B221783848922/requests", 
  {"outboundSMSMessageRequest": {"address": "tel:"+""+tel,"senderAddress": "tel:+221783848922","senderName": "Elmadeal", "outboundSMSTextMessage": 
  {"message": "Votre inscription s'est déroulée avec succès.Votre mot de passe est: elmadeal. "}
  }
}.to_json,
  { content_type: :json, accept: :json, :Authorization => 'Bearer'+' '+token}
    Role.create(user: User.last, role: Role::CUSTOMER)
  end

end
