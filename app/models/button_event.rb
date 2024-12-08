class ButtonEvent < ApplicationRecord
  belongs_to :dog_profile
  has_many :audio_files, dependent: :destroy

  validates :event_type, presence: true
end
