class SiteLabelling < ApplicationRecord
  belongs_to :site, optional: true
  belongs_to :label, optional: true
end
