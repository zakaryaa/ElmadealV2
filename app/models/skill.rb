class Skill < ApplicationRecord
  belongs_to :user, :foreign_key => :customer_id, class_name: 'User'
  belongs_to :service, :foreign_key => :service_id, class_name: 'User'

  scope :employee_skills, -> (salon_id,employee_id){ self.find_by(salon_id: salon_id,employee_id: employee_id)}
end