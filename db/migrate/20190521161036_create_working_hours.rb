class CreateWorkingHours < ActiveRecord::Migration
  def change
    create_table :working_hours do |t|
      t.date :start_shift
      t.date :end_shift
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps null: false
    end
  end
end
