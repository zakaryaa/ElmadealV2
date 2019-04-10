class Service < ApplicationRecord
  belongs_to :salon
  has_many :appointments, dependent: :destroy
  has_many :working_hours, dependent: :destroy
  has_many :users, through: :appointments

  # virtual attribute
  attr_accessor :appointment_count
  def appointment_count
    self.appointments.count
  end

  # validates :name, :category, :duration, :price, :salon, presence: true
  validates :description, length: { in: 0..100 }, allow_nil: true
  validates :duration, inclusion: { in: (0..240) }, allow_nil: true
  monetize :price_cents
  #filters
  scope :salon_categories, -> (id){self.where(salon_id: id).group(:category).count}
  scope :salon_services, -> (id){self.where(salon_id: id)}
  scope :appointment_taken, -> (){self.map{ |s| s.appointment_count = s.appointments.count}}
end
