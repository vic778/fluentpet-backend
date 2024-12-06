class AudioFilesController < ApplicationController
  def create
    audio_file = AudioFile.new(audio_file_params)

    if audio_file.save
      file_url = url_for(audio_file.file)
      render json: { id: audio_file.id, file_url: file_url }, status: :created
    else
      render json: { errors: audio_file.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def audio_file_params
    params.require(:audio_file).permit(:button_id, :timestamp, :duration, :file)
  end
end
