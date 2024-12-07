class AudioFilesController < ApplicationController
  def create
    audio_file = AudioFile.new(audio_file_params)

    if audio_file.save
      ProcessAudioJob.perform_later(audio_file.id)
      file_url = url_for(audio_file.file)

      save_to_dynamodb(audio_file, file_url)

      render json: { id: audio_file.id, file_url: file_url }, status: :created
    else
      render json: { errors: audio_file.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    button_id = params[:button_id]

    if button_id.blank?
      render json: { error: "button_id is required" }, status: :bad_request
      return
    end

    dynamo_service = DynamoDbService.new
    audio_files = dynamo_service.get_audio_files(button_id)

    render json: { button_id: button_id, audio_files: audio_files }, status: :ok
  end

  private

  def audio_file_params
    params.require(:audio_file).permit(:button_id, :timestamp, :duration, :file)
  end

  def save_to_dynamodb(audio_file, file_url)
    dynamo_service = DynamoDbService.new

    dynamo_service.save_audio_file(
      button_id: audio_file.button_id,
      timestamp: audio_file.timestamp.to_s,
      audio_url: file_url,
      duration: audio_file.duration
    )
  end
end
