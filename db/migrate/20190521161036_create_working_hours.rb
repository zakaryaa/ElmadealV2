class CreateWorkingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :working_hours do |t|
      t.string :start_shift
      t.string :end_shift
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps null: false
    end
  end
end
