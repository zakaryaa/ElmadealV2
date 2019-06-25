class CreateOpeningHours < ActiveRecord::Migration[5.2]
  def change
    create_table :opening_hours do |t|
      t.string :day
      t.string :start_hour
      t.string :end_hour
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end
  end
end
