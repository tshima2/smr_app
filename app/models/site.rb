class Site < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true  

  has_many :comments, dependent: :destroy
  has_many :image_posts, dependent: :destroy  
  belongs_to :user
  belongs_to :team
end
