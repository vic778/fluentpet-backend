class DogProfile < ApplicationRecord
  has_one_attached :photo

  validates :photo, attached: true, content_type: ['image/png', 'image/jpg', 'image/jpeg']
end
