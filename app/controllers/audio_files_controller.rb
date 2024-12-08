class AudioFilesController < ApplicationController
  def index
    dog_profile_id = params[:dog_profile_id]

    if dog_profile_id.blank?
      render json: { error: "dog_profile_id is required" }, status: :bad_request
      return
    end

    button_events = ButtonEvent.includes(:audio_files)
                               .where(dog_profile_id: dog_profile_id)
                               .order(created_at: :desc)

    render template: "audio_files/index", locals: { button_events: button_events }
  end

  def create
    audio_file = AudioFile.new(audio_file_params)

    if audio_file.save
      ProcessAudioJob.perform_later(audio_file.id)
      file_url = url_for(audio_file.file)

      render json: { id: audio_file.id, file_url: file_url }, status: :created
    else
      render json: { errors: audio_file.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def audio_file_params
    params.require(:audio_file).permit(:timestamp, :duration, :file, :button_event_id)
  end
end
