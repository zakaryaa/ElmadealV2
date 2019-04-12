class OpeningHour < ApplicationRecord
  belongs_to :salon

  validates :day, :start_hour, :end_hour, :salon, presence: true
  validates :day, inclusion: { in: %w(Lundi Mardi Mercredi Jeudi Vendredi Samedi Dimanche), message: "You have not provided a valid day of the week." }
 # validate :validates_hours

  private

  def validates_hours
    errors.add(:end_hour, "must be after the start shift") if end_hour <= start_hour
  end
end