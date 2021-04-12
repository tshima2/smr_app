class Site < ApplicationRecord
  acts_as_taggable
  
  validates :name, presence: true
  validates :address, presence: true  

  has_many :comments, dependent: :destroy
  has_many :image_posts, dependent: :destroy  
  belongs_to :user
  belongs_to :team

  has_many :site_labellings, dependent: :destroy, foreign_key: 'site_id'
  has_many :labels, through: :site_labellings, source: :label
end
