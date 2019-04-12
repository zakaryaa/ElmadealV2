class Appointment < ApplicationRecord
  attr_accessor :service_category

  A_VALIDER = "À valider"
  VALIDE = "Validé"
  EN_COURS = "En cours"
  TERMINE = "Terminé"

  belongs_to :customer, class_name: 'User', optional: true
  belongs_to :employee, class_name: 'User', optional: true

  belongs_to :service

  validates :start_appointment, :end_appointment, :customer_id, :service, presence: true

end