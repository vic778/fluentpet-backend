json.dog_profile do
  json.id dog_profile.id
  json.name dog_profile.name
  json.breed dog_profile.breed
  json.age dog_profile.age
  json.photo_url photo_url
  json.metadata do
    json.size dog_profile.metadata["size"]
    json.width dog_profile.metadata["width"]
    json.height dog_profile.metadata["height"]
    json.format dog_profile.metadata["format"]
  end
end
