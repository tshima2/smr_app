class UsersController < ApplicationController
  before_action  :check_guest_user, only: [:edit]

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      sign_in(current_user, bypass: true)
      flash[:notice]=I18n.t('views.messages.update_profile')
      redirect_to user_path
    else
      flash[:alert]=I18n.t('views.messages.failed_update_profile')
      render 'edit'
    end
  end

  def show
    @user = current_user
  end
   private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :icon, :icon_cache, :name, :keep_team_id)
  end
end
  
