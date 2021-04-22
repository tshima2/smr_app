# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  private

  def after_sign_in_path_for(user)
    keep_team = user.keep_team_id
    if keep_team.nil?
      if user.teams.count == 1
        team_url(user.teams.first.id)
      else
        user_url
      end
    else
      stored_location_for(user) || team_url(keep_team)
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
