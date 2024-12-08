module AudioFilesHelper
  def hashed_data(button_events)
    button_events.map do |button_event|
      {
        id: button_event.id,
        button_id: button_event.button_id,
        pressed_on: button_event.timestamp.strftime("%m/%d/%Y %H:%M:%S"),
        audio_files: button_event.audio_files.map do |audio_file|
          {
            id: audio_file.id,
            button_event_id: audio_file.button_event_id,
            registrested_on: audio_file.timestamp.strftime("%m/%d/%Y %H:%M:%S"),
            duration: audio_file.duration,
            file: url_for(audio_file.file)
          }
        end
      }
    end
  end
end
