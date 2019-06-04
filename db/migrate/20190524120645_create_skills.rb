class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :employee_id, :null => false, :references => [:users, :id]
      t.integer :service_id, :null => false, :references => [:services, :id]
      t.timestamps null: false
    end
  end
end
