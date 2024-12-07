class ProcessAudioJob < ApplicationJob
  queue_as :default

  def perform(audio_file_id)
    # Step 1: Fetch the audio file from the database
    audio_file = AudioFile.find(audio_file_id)
    return unless audio_file

    # Step 2: Validate the audio file
    # Example: Ensure the duration is within acceptable limits
    if audio_file.duration.nil? || audio_file.duration <= 0 || audio_file.duration > 300
      audio_file.update(metadata: { error: "Invalid duration" })
      raise StandardError, "Invalid audio duration for file ID: #{audio_file_id}"
    end

    # Step 3: Process Metadata (Optional)
    # Add extra metadata for future reference
    metadata = audio_file.metadata || {}
    metadata.merge!(
      processed_at: Time.current,
      file_size: audio_file.file.blob.byte_size,
      content_type: audio_file.file.blob.content_type
    )
    audio_file.update(metadata: metadata)

    # Step 4: Generate a public URL for the audio file
    public_url = Rails.application.routes.url_helpers.rails_blob_url(audio_file.file, only_path: false)
    audio_file.update(metadata: metadata.merge(public_url: public_url))

    # Step 5: Logging or Notify (Optional)
    Rails.logger.info "Audio file #{audio_file_id} processed successfully."
  rescue StandardError => e
    # Handle exceptions, log errors, and re-raise for retries if needed
    Rails.logger.error "Error processing audio file #{audio_file_id}: #{e.message}"
    raise e
  end
end
