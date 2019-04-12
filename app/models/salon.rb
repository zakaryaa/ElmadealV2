class Salon < ApplicationRecord
  has_many :services, dependent: :destroy
  has_many :opening_hours, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :roles

  has_many :appointments, through: :services
  has_many :users, through: :roles

  validates :name, :city, :address, :phone_number, presence: true
  validates :name, uniqueness: { scope: :city }, length: { minimum: 2 }
  validates :description, length: { in: 0..100 }, allow_nil: true
  validates :phone_number, format: { with: /\A\(?\d{3}\)?[- ]?\d{9}\z/, message: I18n.t('global.errors.phone_format') }

  scope :top_services, -> (id){ self.find(id).services.sort {|s1,s2| s1.appointment_count <=> s2.appointment_count }}
  scope :revenues, -> (id){ self.find(id).appointments.sum{ |a| (a.status == Appointment::TERMINE && !a.service.price_cents.nil?) ? a.service.price_cents : 0 }}
  scope :client_count, -> (id){ self.find(id).roles.where(role: Role::CUSTOMER).count}
  scope :appointment_ongoing_count, -> (id){ self.find(id).appointments.where(status: Appointment::VALIDE, status: Appointment::EN_COURS,status: Appointment::A_VALIDER).count}
  scope :appointment_done_count, -> (id){ self.find(id).appointments.where(status: Appointment::TERMINE).count}
end