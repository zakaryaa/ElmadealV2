class AddEmployeeIdToAppointments < ActiveRecord::Migration[5.2]
  def change
    add_column :appointments, :employee_id, :integer
    add_column :appointments, :customer_id, :integer
    add_foreign_key :appointments, :users, column: :employee_id, primary_key: :id
    add_foreign_key :appointments, :users, column: :customer_id, primary_key: :id
    remove_column :appointments, :user_id
  end
end
