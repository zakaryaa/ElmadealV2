class WorkingHour < ActiveRecord::Base
  belongs_to :user
  belongs_to :service

  # validates :start_shift, :end_shift, :user, :service, presence: true
  validate :validates_shifts

  private

  def validates_shifts
    errors.add(:end_shift, "must be after the start shift") if end_shift <= start_shift
  end
end
