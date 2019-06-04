class CreateSalons < ActiveRecord::Migration
  def change
    create_table :salons do |t|

      t.string :name
      t.text :description
      t.string :address
      t.string :city
      t.integer :phone_number
      t.string :latitude
      t.string :longitude
      t.timestamps null: false
    end
  end
end
