class ImagePostsController < ApplicationController
  def new
    @site = Site.find(params[:site_id])
    @team = @site.team

    @image_post = @site.image_posts.build
  end

  def create
    @site ||= Site.find(params[:site_id])
    @image_post = @site.image_posts.build(image_post_params)
    @image_post.user_id = current_user.id
    
    byebug
    if @image_post.save
      redirect_to team_site_path(@site.team.id, @site.id), notice: I18n.t('view.messages.create_image_post')
    else
      redirect_to team_site_path(@site.team.id, @site.id), notice: I18n.t('view.messages.failed_create_image_post')
    end
  end

  def destroy
    byebug
    @image_post = ImagePost.find(params[:id])
    @image_post.destroy
    redirect_to team_site_path(@image_post.site.team.id, @image_post.site.id), notice: I18n.t('views.messages.delete_image_post')
  end   

  private
  def image_post_params
    byebug
    params.require(:image_post).permit(:site_id, :image, :image_cache)
  end
end