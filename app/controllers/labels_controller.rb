class LabelsController < ApplicationController
  before_action :set_label, only: [:show, :edit, :update, :destroy]
  def index
    @labels = Label.filter_team(current_user.keep_team_id)
  end

  def show
  end 

  def new
    @label = Label.new
  end

  def edit
  end   

  def create
    @label=Label.new(label_params)
    @label.team_id = current_user.keep_team_id
    if @label.save
      flash[:notice]=I18n.t('views.messages.create_label')
      redirect_to @label
    else
      flash[:alert]=I18n.t('views.messages.failed_create_label')
      redirect_to @label
    end        
  end

  def update
    if @label.update(label_params)
      flash[:notice]=I18n.t('views.messages.update_label')
      redirect_to @label
    else
      flash[:alert]=I18n.t('views.messages.failed_update_label')
      redirect_to @label
    end
  end

  def destroy
    if @label.destroy
      flash[:notice]=I18n.t('views.messages.delete_label')
      redirect_to labels_path
    else
      flash[:alert]=I18n.t('views.messages.failed_delete_label')
      redirect_to labels_path
    end 
  end

  private
  def set_label
    @label = Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:title)
  end
end
