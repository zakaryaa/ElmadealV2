class Role < ActiveRecord::Base
  OWNER = "Owner"
  EMPLOYEE = "Employee"
  CUSTOMER = "Customer"

  belongs_to :user
  belongs_to :salon

  validates :role, inclusion: { in: [OWNER,EMPLOYEE,CUSTOMER], message: "Seulement les roles : Owner, Employee et Customer sont permis" }

end
