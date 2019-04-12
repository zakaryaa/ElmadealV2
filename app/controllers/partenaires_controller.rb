class PartenairesController < ApplicationController
  
  after_action :verify_authorized, except: [:index,:new,:create]
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @partenaire = Partenaire.new
  end

  def create  
    @partenaire = Partenaire.new(partenaire_params)
    
    if Partenaire.exists?(telephone: partenaire_params[:telephone]) # I think this should be `user_params[:email]` instead of `params[:email]`
      redirect_to new_partenaire_path, alert: 'Numéro Téléphone déjà utilisé' 
      return 
    end
      if @partenaire.save
        redirect_to root_path, notice: 'Nous vous contacterons bientôt.Merci' 
        return 
      else
        redirect_to new_partenaire_path, alert:'Veuillez remplir les champs obligatoires.'
        return 
      end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partenaire
      @partenaire = Partenaire.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partenaire_params
      params.require(:partenaire).permit(:prenom, :nom, :telephone, :email, :nomInstitut, :adresseInstitut, :message)
    end
end
