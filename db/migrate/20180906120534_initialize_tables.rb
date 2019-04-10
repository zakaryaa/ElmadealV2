class InitializeTables < ActiveRecord::Migration[5.2]
  def change
    create_table :salons do |t|
      t.string :name
      t.string :description
      t.string :address
      t.string :city
      t.string :phone_number
      t.timestamps null: false
    end

    create_table :services do |t|
      t.string :name
      t.string :description
      t.integer :duration
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end

    create_table :appointments do |t|
      t.datetime :start_appointment
      t.datetime :end_appointment
      t.string :status
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps null: false
    end

    create_table :working_hours do |t|
      t.datetime :start_shift
      t.datetime :end_shift
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true
      t.timestamps null: false
    end

    create_table :opening_hours do |t|
      t.string :day
      t.time :start_hour
      t.time :end_hour
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end

    create_table :photos do |t|
      t.string :photo_url
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end
  end
end
