class ApplicationController < ActionController::Base
    before_action :store_current_location, unless: :devise_controller?
    before_action :authenticate_user!
    before_action :init_team, if: :user_signed_in?
    before_action :set_working_team, if: :user_signed_in?

    def change_keep_team(user, current_team)
      user.keep_team_id = current_team.id
      user.save!
    end
  
    private
    def set_working_team
      @working_team = current_user.keep_team_id ? Team.find(current_user.keep_team_id) : Team.first
    end
  
    def init_team
      current_user.assigns.create!(team_id: Team.first.id) if current_user.teams.blank?
    end

    def check_specified_team
      unless (@site.team_id == current_user.keep_team_id) && (current_user.teams.pluck(:team_id).include?(@site.team_id))
        #render partial: 'unauthrized_request'
        redirect_to statics_top_path, alert: I18n.t('views.messages.unauthorized_request')
      end 
    end

    def store_current_location
      store_location_for(:user, request.url)
    end
end