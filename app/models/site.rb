class Site < ApplicationRecord
  acts_as_taggable

  validates :name, presence: true, length: {maximum: 128}
  validates :address, presence: true, length: {maximum: 255}
  validates :memo, length: {maximum: 255}

  has_many :comments, dependent: :destroy
  has_many :image_posts, dependent: :destroy
  belongs_to :user
  belongs_to :team

  has_many :site_labellings, dependent: :destroy, foreign_key: 'site_id'
  has_many :labels, through: :site_labellings, source: :label
end
