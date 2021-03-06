class ApplicationController < ActionController::Base
  before_action :store_current_location, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :under_statics_top?
  before_action :init_team, if: :user_signed_in?
  before_action :set_working_team, if: :user_signed_in?

  def change_keep_team(user, current_team)
    user.keep_team_id = current_team.id
    user.save!
  end

  private
  def under_statics_top?
    (controller_name == "statics")? true : false
  end

  def check_guest_user
    if current_user.guest?
      flash[:alert] = I18n.t('views.messages.guest_can_only_allowed_viewing')
      redirect_to request.referer 
    end 
  end

  def set_working_team
    begin
      @working_team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : Team.first
    rescue ActiveRecord::RecordNotFound
      @working_team = Team.first
      current_user.keep_team_id=Team.first.id
    end
  end

  def init_team
    current_user.assigns.create!(team_id: Team.first.id) if current_user.teams.blank?
  end

  def store_current_location
    store_location_for(:user, request.url)
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
