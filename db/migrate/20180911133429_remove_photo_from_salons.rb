class RemovePhotoFromSalons < ActiveRecord::Migration[5.2]
  def change
    remove_column :salons, :photo, :string
  end
end
