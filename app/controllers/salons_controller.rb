  class SalonsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new]
  before_action :set_salon, only: [:show, :update, :edit, :destroy]
  after_action :verify_authorized, except: [:index]


  def index
  # Retourne l'ensemble des salons équivalent à Salon.all
  @salons = policy_scope(Salon)
  # Filter les salons par ville
  @salons = @salons.where(city: params[:city]) if !params[:city].nil?
  # Liste des ids salons correspondant à la categorie (Déjà filtré par ville)
  @salons = policy_scope(Salon) if params[:city] == '' and !params[:category].nil?

  if params[:city]=='' and !params[:category].nil?
    @salons = @salons.where(city: 'dakar')
    @salons = @salons.reject{ |salon| salon.services.where(category: params[:category]).count == 0 }
  end
  @salons = @salons.reject{ |salon| salon.services.where(category: params[:category]).count == 0 } if !params[:category].nil?
  @salons = policy_scope(Salon) if params[:city] == '' and params[:category].nil?
 
  @markers = @salons.map do |salon|
    {
      lng: salon.longitude,
      lat: salon.latitude,
    }
  end

  if  @salons == []
    flash.now[:alert] = 'Aucune correspondance trouvée.'
  else
    flash.now[:notice] = 'Les salons correspondants à votre recherche.'
  end
  end

    #  @salons.each do |salon|
     #   puts '111111--------------------------------------'
      #  if params[:category] && !salon.services.map {|service| service.category }.include?(params[:category])
       #   @salons.delete(salon)
      #  end
     # end
    # Recherche par ville et service
   # else
    #  puts '333333--------------------------------------'  
    #  policy_scope(Salon).where(city: params[:city].downcase).each do |salon|
    #    @salons << salon
    #  end
    #  @salons.each do |salon|
     #   if params[:service] && !salon.services.map { |service| service.name }.include?(params[:service])
     #   puts '2222222--------------------------------------'  
     #   @salons.delete(salon)
     #   end
     # end
    # end
   
   # @markers = @salons.map do |salon|
     
    #  {
     #   lng: salon.longitude,
      #  lat: salon.latitude,
     # }
      
   # end
 # end

  def show
    @appointment = Appointment.new
    @servicesByCategory = Service.where(salon_id: @salon.id ).group_by{|x| x.category}.values
    @openingHours= OpeningHour.where(salon_id: @salon.id)

  end

  def create
    @salon = Salon.new(salon_params)
    @salon.user = current_user
    if @salon.save
      if params[:photos]['photo'].length > 0
        params[:photos]['photo'].each do |a|
            @photo = @salon.photos.create!(photo: a)
        end
      end
      if params[:salon]["equip_ids"].length > 0
        params[:salon]["equip_ids"].each do |p|
        JoinAptEquip.create(salon_id: @salon.id, equip_id: p)
        end
      end
        redirect_to salon_path(@salon)
      else
        render :new
    end
      authorize @salon
  end


  def new
    @salon = Salon.new
    authorize @salon
    #@photo = @apartment.photos.build


  end

  def edit
  end

  # def update
  #   if @salon.update(salon_params)
  #     if params[:photos]
  #       params[:photos]['photo'].each do |a|
  #         @photo = @salon.photos.create!(photo: a)
  #       end
  #     end
  #     services = Service.where(salon: @salon)
  #     services.each do |j|
  #       j.destroy
  #     end
  #     if params[:salon]["equip_ids"]
  #       params[:salon]["equip_ids"].each do |p|
  #         Service.create(salon_id: @salon.id, equip_id: p)
  #       end
  #     end
  #     redirect_to salon_path(@salon)
  #   else
  #     render :edit 
  #   end
  # end

  def destroy
    @salon.destroy
    redirect_to salon_path(@salon)
  end

  private

  def salon_params
    params.require(:salon).permit(:name, :address, :city, :description, :phone_number, :photo, photos_attributes: [:id, :salon_id, :photo])
  end

  def set_salon
    @salon = Salon.find(params[:id])
    authorize @salon
  end
end
