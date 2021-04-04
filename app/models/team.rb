class Team < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  has_many :users, foreign_key: :keep_team_id

end
