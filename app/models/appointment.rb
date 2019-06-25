class Appointment < ActiveRecord::Base
  attr_accessor :service_category

  A_VALIDER = "À valider"
  VALIDE = "Validé"
  EN_COURS = "En cours"
  TERMINE = "Terminé"


  belongs_to :customer, class_name: 'User'
  belongs_to :employee, class_name: 'User'

  belongs_to :service

  validates :start_appointments, :end_appointments, :customer_id, :service, presence: true


end
