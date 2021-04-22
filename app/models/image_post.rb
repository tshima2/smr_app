class ImagePost < ApplicationRecord
  attr_accessor :team_id

  validates :image, presence: true
  belongs_to :user
  belongs_to :site

  mount_uploader :image, ImageUploader
end
