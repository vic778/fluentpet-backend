FactoryBot.define do
  factory :dog_profile do
    name { "MyString" }
    breed { "MyString" }
    age { 1 }
    photo { nil }
    metadata { "" }
  end
end
