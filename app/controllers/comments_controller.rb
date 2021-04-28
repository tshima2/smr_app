class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @site = Site.find(params[:site_id])
    @comment = @site.comments.build(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        # format.html { redirect_to team_site_path(@site.team_id, @site.id) }
        flash[:notice] = I18n.t('views.messages.post_comment')
        format.js { render :index }
      else
        flash[:alert] = I18n.t('views.messages.failed_to_post_comment')
        format.html { redirect_to team_site_path(@site.team_id, @site.id), alert: I18n.t('views.messages.failed_to_post_comment') }
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @site = @comment.site

    respond_to do |format|
      flash.now[:notice] = I18n.t('views.messages.editing_comment')
      format.js { render :edit }
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @site = @comment.site
      respond_to do |format|
        if @comment.update(comment_params)
          flash.now[:notice] = I18n.t('views.messages.update_comment')
          format.js { render :index }
        else
          flash.now[:alert] = I18n.t('views.messages.failed_to_update_comment')
          format.js { render :edit_error }
        end
      end
  end

  def destroy
    _site_id = @comment.site_id
    _team_id = @comment.site.team_id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to team_site_path(_team_id, _site_id, anchor: "comments"), notice: I18n.t('views.messages.delete_comment') }
      format.json { head :no_content }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:site_id, :content)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end 
end
