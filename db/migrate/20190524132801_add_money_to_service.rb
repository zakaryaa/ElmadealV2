class AddMoneyToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :money, :string
  end
end
