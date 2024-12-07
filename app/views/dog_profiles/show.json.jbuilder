json.dog_profile do
  json.id dog_profile.id
  json.name dog_profile.name
  json.breed dog_profile.breed
  json.age dog_profile.age
  json.photo_url photo_url
  jsonb.metadata do
    jsonb.size dog_profile.metadata["size"]
    jsonb.width dog_profile.metadata["width"]
    jsonb.height dog_profile.metadata["height"]
    jsonb.format dog_profile.metadata["format"]
  end
end
