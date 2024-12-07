class DogProfile < ApplicationRecord
  has_one_attached :photo
  validates :photo, attached: true, content_type: [ "image/png", "image/jpg", "image/jpeg" ]

  after_commit :extract_photo_metadata, on: :create

  private

  def extract_photo_metadata
    return unless photo.attached?

    photo.open do |file|
      dimensions = FastImage.size(file.path)
      format = FastImage.type(file.path)
      update(metadata: { width: dimensions[0], height: dimensions[1], format: format, size: photo.byte_size })
    end
  end
end
