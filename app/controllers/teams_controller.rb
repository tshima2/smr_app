class TeamsController < ApplicationController
  before_action :set_team, only: %i[show edit update destroy delegate]
  def index
    @teams = Team.all
  end

  def show
    @working_team = @team
    change_keep_team(current_user, @team)
  end

  def new
    @team = Team.new
  end

  def edit
    if !(team_owner?)
      flash[:alert]=I18n.t('views.messages.unauthorized_request')
      redirect_to statics_top_path
    end
  end

  def delegate
    @team.owner_id = params[:owner_id]

    if @team.save
      TeamMailer.delegate_leader_mail(@team.owner.email, @team.name).deliver
      flash[:notice]=I18n.t('views.messages.delegate_leader')
      redirect_to @team
    else
      flash[:alert] = I18n.t('views.messages.failed_to_delegate_leader')
      render :new
    end
  end

  def create
    @team = Team.new(team_params)
    @team.owner = current_user
    if @team.save
      @team.invite_member(@team.owner)
      flash[:notice] = I18n.t('views.messages.create_team')
      redirect_to @team
    else
      flash[:alert] = I18n.t('views.messages.failed_to_save_team')
      render :new
    end
  end

  def update
    if @team.update(team_params)
      flash[:notice] = I18n.t('views.messages.update_team')
      redirect_to @team
    else
      flash[:alert] = I18n.t('views.messages.failed_to_save_team')
      render :edit
    end
  end

  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('views.messages.delete_team')
  end

  private
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.fetch(:team, {}).permit %i[name icon icon_cache owner_id keep_team_id]
  end

  def team_owner?
    (current_user.id == @team.owner_id) ? true : false
  end
end
