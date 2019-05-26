class Photo < ActiveRecord::Base
  belongs_to :salon

  validates :photo_url, presence: true

end
