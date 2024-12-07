FactoryBot.define do
  factory :audio_file do
    button_id { "MyString" }
    timestamp { "2024-12-06 23:18:34" }
    duration { 1 }
    file { nil }
    metadata { "" }
  end
end
