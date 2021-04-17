class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :teams, foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  has_many :teams, through: :assigns
  has_many :sites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :image_posts, dependent: :destroy

  belongs_to :keep_team, optional: true, class_name: 'Team', foreign_key: :keep_team_id

  mount_uploader :icon, ImageUploader

end
