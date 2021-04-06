class Site < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true  
  belongs_to :user
  belongs_to :team
end
