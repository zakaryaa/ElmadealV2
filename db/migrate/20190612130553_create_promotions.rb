class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.integer :percentage
      t.integer :service_id, :null => false, :references => [:services, :id]

      t.timestamps
    end
  end
end
