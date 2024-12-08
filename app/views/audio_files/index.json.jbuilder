json.button_events do
  button_events.each do |button_event|
    json.id button_event.id
    json.button_id button_event.button_id
    json.pressed_on button_event.timestamp.strftime("%m/%d/%Y %H:%M:%S")

    json.audio_files button_event.audio_files do |audio_file|
      json.id audio_file.id
      json.registrested_on audio_file.timestamp.strftime("%m/%d/%Y %H:%M:%S")
      json.duration audio_file.duration
      json.file_url url_for(audio_file.file)
    end
  end
end
