class Team < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  
  has_many :assigns, dependent: :destroy
  accepts_nested_attributes_for :assigns, allow_destroy: true

  has_many :members, through: :assigns, source: :user
  has_many :sites, dependent: :destroy
  has_many :users, foreign_key: :keep_team_id

  mount_uploader :icon, ImageUploader

  def invite_member(user)
    assigns.create(user: user)
  end
end
