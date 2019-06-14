class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
     t.text :comment
     t.integer :customer_id
     t.references :salon, foreign_key: true

      t.timestamps
    end
    add_foreign_key :ratings, :users, column: :customer_id, primary_key: :id

  end
end
