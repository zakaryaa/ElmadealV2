class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :roles, dependent: :destroy
  has_many :employee_appointments, class_name: 'Appointment', dependent: :destroy, foreign_key: :employee_id
  has_many :customer_appointments, class_name: 'Appointment', dependent: :destroy, foreign_key: :customer_id
  has_many :working_hours, dependent: :destroy
  has_many :services, through: :appointments
  has_many :salons, through: :roles

  def email_required?
    false
  end

  def email_changed?
    false
  end

  validates :phone_number,  presence: { message: "est un champs  obligatoire" }
  validates :first_name, presence: { message: "est un champs obligatoire" }
  validates :last_name, presence: { message: "est un champs obligatoire"}
  validates :phone_number, uniqueness:{ message:"est déja utilisé"}
  #validates :phone_number, format: { with: /\A\(?\d{3}\)?[- ]?\d{3}[- ]?\d{4}\z/, message: I18n.t('global.errors.phone_format') }

end