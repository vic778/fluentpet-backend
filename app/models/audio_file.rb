class AudioFile < ApplicationRecord
  belongs_to :button_event
  has_one_attached :file
end
