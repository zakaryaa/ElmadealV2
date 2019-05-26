class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :role
      t.references :user, foreign_key: true
      t.references :salon, foreign_key: true

      t.timestamps null: false
    end
  end
end
