class AddPhotoToSalons < ActiveRecord::Migration[5.2]
  def change
    add_column :salons, :photo, :string
  end
end
