class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|

      t.string :name
      t.text :description
      t.integer :duration
      t.string :category
      t.float :price_cents
      t.references :salon, foreign_key: true
      t.timestamps null: false
    end
  end
end
