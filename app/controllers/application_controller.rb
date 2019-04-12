include Pundit
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :store_location_for_redirect, only: :create
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, :init_search

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:index], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  protected

  def after_sign_up_path_for(resource)
    unless  session[:forwarding_url].nil?
      redirect_after_identification(resource)
    else
      super
    end
  end

  def after_sign_in_path_for(resource)
    if !session[:forwarding_url].nil?
      redirect_after_identification(resource)
    elsif resource.class  == User
      if resource.roles.pluck(:role).include?(Role::OWNER)
      dashboard_path(current_user.salons[0])
      else
        super
      end
    elsif resource.class  == Admin
      rails_admin_path
    else
      super
    end
    end

  def after_sign_out_path_for(resource_or_scope)
      puts request.referrer
      if request.referrer.include? 'backoffice/dashboard/'
        connexion_institut_path
    else
      root_path
    end
  end

  def redirect_after_identification(resource)
      redirect_info = Hash.new
      redirect_info = session[:params]
      redirect_info.merge!(forwarding_url: session[:forwarding_url])
      session.delete(:params)
      session.delete(:forwarding_url)
      appointment_path(AppointmentsController.new.create_without_redirect(redirect_info["service_id"],redirect_info["appointment"]["start_date_time"],resource.id))
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email, :address, :remember_me])
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def store_location_for_redirect
    if params[:controller] == "appointments"
      session[:forwarding_url] = request.original_url
      session[:params] = params
    end
  end

  def skip_pundit?
    devise_controller? || params[:controller]  =~ /(^(rails_)?admin)|(^pages$)/
  end

  def init_search
    @search = true
  end

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.available_locales.include?(locale) ?
        locale :
        I18n.default_locale
  end
  def mobile_device?
    if (request.user_agent =~ /Mobile|webOS/) && (request.user_agent !~ /iPad/)
      return 'mobile'
    else
      return 'non mobile'
    end
  end

  helper_method:mobile_device?

  def check_for_mobile
    prepare_for_mobile if mobile_device?
  end

  def prepare_for_mobile
    prepend_view_path Rails.root + 'app' + 'views_mobile'
  end
end