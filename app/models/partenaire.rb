class Partenaire < ApplicationRecord
validates :prenom, presence: { message: "est un champs est obligatoire" }
  validates :nom, presence: { message: "est un champs est obligatoire" }
  validates :telephone, presence: { message: "est un champs est obligatoire"}
  validates :nomInstitut, presence: { message: "est un champs est obligatoire"}
  validates :adresseInstitut, presence: { message: "est un champs est obligatoire"}
  validates :message, presence: { message: "est un champs est obligatoire"}
end
