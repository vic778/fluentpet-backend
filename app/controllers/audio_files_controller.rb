class AudioFilesController < ApplicationController
  include AudioFilesHelper

  def index
    dog_profile_id = params[:dog_profile_id]

    if dog_profile_id.blank?
      return render json: { error: "dog_profile_id is required" }, status: :bad_request
    end

    # Try fetching from different sources
    redis_data = $redis.get("button_events_dog_id_#{dog_profile_id}")
    button_events = redis_data.present? ? JSON.parse(redis_data) : nil

    if button_events.blank?
      button_events = ButtonEvent.includes(:audio_files)
                                 .where(dog_profile_id: dog_profile_id)
                                 .order(created_at: :desc)
    end

    if button_events.blank?
      button_events = DynamoDbService.new.get_button_events(dog_profile_id)
    end

    if button_events.blank?
      return render json: { error: "No button events found" }, status: :not_found
    end

    # Hash the data only if it is not coming from Redis
    unless redis_data.present?
      button_events = hashed_data(button_events)
      $redis.set("button_events_dog_id_#{dog_profile_id}", button_events.to_json, ex: 3600) # Expire in 1 hour
    end

    render json: { button_events: button_events }

    # render template: "audio_files/index", locals: { button_events: button_events }
  end

  def create
    audio_file = AudioFile.new(audio_file_params)

    if audio_file.save
      ProcessAudioJob.perform_later(audio_file.id)
      file_url = url_for(audio_file.file)

      send_audio_to_dynamo_db(audio_file, file_url)

      render json: { id: audio_file.id, file_url: file_url }, status: :created
    else
      render json: { errors: audio_file.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def audio_file_params
    params.require(:audio_file).permit(:timestamp, :duration, :file, :button_event_id)
  end

  def send_audio_to_dynamo_db(audio_file, file_url)
    dynamo_db_service = DynamoDbService.new
    dynamo_db_service.save_audio_file(
      button_id: audio_file.button_event_id,
      timestamp: audio_file.timestamp,
      audio_url: file_url,
      duration: audio_file.duration
    )
  end
end
