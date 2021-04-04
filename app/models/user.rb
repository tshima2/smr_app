class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :teams, foreign_key: :owner_id
  belongs_to :keep_team, optional: true, class_name: 'Team', foreign_key: :keep_team_id
  
end
