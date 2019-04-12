require 'json'
class BackofficeController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_policy_scoped, unless: :index

  def index
    salon_id = params[:salon_id]
    @salon = Salon.find(salon_id)
    @salons = current_user.salons.to_a.delete_if {|salon| salon.id == salon_id.to_i }

    @top5_services = Salon.top_services(salon_id).take(5)
    @revenues = Salon.revenues(salon_id)
    @client_count = Salon.client_count(salon_id)
    @appointment_ongoing_count = Salon.appointment_ongoing_count(salon_id)
    @appointment_done_count = Salon.appointment_done_count(salon_id)

    authorize @salon

  end

end