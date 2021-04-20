class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
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
    params.require(:user).permit(:email, :icon, :name, :keep_team_id)
  end
end
  
