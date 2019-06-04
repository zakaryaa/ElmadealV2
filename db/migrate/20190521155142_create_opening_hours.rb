class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.string :day
      t.date :start_hour
      t.date :end_hour
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end
  end
end
