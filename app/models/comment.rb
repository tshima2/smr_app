class Comment < ApplicationRecord
  validates :content, presence: true, length: {maximum: 4096}

  belongs_to :user
  belongs_to :site
end
