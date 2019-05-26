class AddMoneyToService < ActiveRecord::Migration
  def change
    add_column :services, :money, :string
  end
end
