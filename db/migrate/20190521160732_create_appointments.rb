class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.date :start_appointments
      t.date :end_appointments
      t.string :status
      t.integer :employee_id
      t.integer :customer_id
      t.references :service, foreign_key: true
      t.timestamps null: false
    end

    add_foreign_key :appointments, :users, column: :employee_id, primary_key: :id
    add_foreign_key :appointments, :users, column: :customer_id, primary_key: :id
  end
end
