class Label < ApplicationRecord
  validates :title, presence: true
  
  belongs_to :team
  has_many :site_labellings, dependent: :destroy, foreign_key: 'label_id'
  has_many :sites, through: :site_labellings, source: :site

  scope :filter_team, ->(_team_id){ where(team_id: _team_id).order(updated_at: :desc) if _team_id.present? }

end
