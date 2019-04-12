class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  def home
    @salons = policy_scope(Salon).random(3)
    @services_names = Service.pluck(:name).uniq
     @servicesByCategory = Service.where(salon_id: @salons.pluck(:id)).group_by{|x| x.category}.values
     @categories = ['Coiffure', 'Mains & Pieds', 'Massage', 'Visage', 'Epilation', 'spa','Corps']
  end
end