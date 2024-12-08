class ButtonEvent < ApplicationRecord
  belongs_to :dog_profile
  validates :event_type, presence: true
end
