class CreateJwtBlacklists < ActiveRecord::Migration[5.2]
  def change
    create_table :jwt_blacklists do |t|
      t.string :jti
      t.datetime :exp

      t.timestamps null: false
    end
    add_index :jwt_blacklists, :jti
  end
end
