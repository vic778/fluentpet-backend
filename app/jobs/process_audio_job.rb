class ProcessAudioJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 5

  def perform(audio_file_id)
    # Fetch the audio file from the database
    audio_file = AudioFile.find(audio_file_id)
    return unless audio_file

    # Example: Ensure the duration is within acceptable limits
    if audio_file.duration.nil? || audio_file.duration <= 0 || audio_file.duration > 300
      audio_file.update(metadata: { error: "Invalid duration" })
      raise StandardError, "Invalid audio duration for file ID: #{audio_file_id}"
    end

    # Add extra metadata for future reference
    metadata = audio_file.metadata || {}
    metadata.merge!(
      processed_at: Time.current,
      file_size: audio_file.file.blob.byte_size,
      content_type: audio_file.file.blob.content_type
    )
    audio_file.update(metadata: metadata)

    # Generate a public URL for the audio file
    public_url = Rails.application.routes.url_helpers.rails_blob_url(audio_file.file, only_path: false)
    audio_file.update(metadata: metadata.merge(public_url: public_url))

    # Logging or Notify (Optional)
    cache_audios(audio_file)
    Rails.logger.info "Audio file #{audio_file_id} processed successfully."
  rescue StandardError => e
    Rails.logger.error "Error processing audio file #{audio_file_id}: #{e.message}"
    raise e
  end

  def cache_audios(audio_data)
    key = "latest_audio:#{audio_data.button_id}"
    $redis.setex(key, 1.days, audio_data.to_json)
  end
end
