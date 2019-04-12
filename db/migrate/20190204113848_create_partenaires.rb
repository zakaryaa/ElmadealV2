class CreatePartenaires < ActiveRecord::Migration[5.2]
  def change
    create_table :partenaires do |t|
      t.string :prenom, null: false
      t.string :nom, null: false
      t.string :telephone, unique: true, null: false
      t.string :email,null: false
      t.string :nomInstitut, null: false
      t.string :adresseInstitut, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
