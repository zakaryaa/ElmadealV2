class AppointmentSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :service

  belongs_to :customer, class_name: 'User'
  belongs_to :employee, class_name: 'User'

  attributes :id,:start_appointment,:end_appointment,:status,:service_category,:service,:customer,:employee
end