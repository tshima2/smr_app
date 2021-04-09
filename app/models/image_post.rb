class ImagePost < ApplicationRecord
  attr_accessor :team_id

  belongs_to :user
  belongs_to :site

  mount_uploader :image, ImageUploader
end
