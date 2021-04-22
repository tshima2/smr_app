class Comment < ApplicationRecord
  validates :content, presence: true, length: {maximum: 1024}

  belongs_to :user
  belongs_to :site
end
