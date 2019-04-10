class Photo < ApplicationRecord
  belongs_to :salon

  validates :photo_url, presence: true
end

