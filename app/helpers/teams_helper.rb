module TeamsHelper
  def default_img(image)
    image.presence || 'default.jpg'
  end 
end