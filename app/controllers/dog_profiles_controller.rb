class DogProfilesController < ApplicationController
  def recent_events
    cache_key = "recent_events:dog:#{params[:dog_id]}"
    events = $redis.get(cache_key)

    unless events
      events = ButtonEvent.includes(:dog_profile).where(dog_profile_id: params[:dog_id]).order(timestamp: :desc).limit(10)
      $redis.set(cache_key, events.to_json, ex: 1.day)
    end

    render json: JSON.parse(events)
  end

  def create
    dog_profile = DogProfile.new(dog_profile_params)

    if dog_profile.save
      photo_url = url_for(dog_profile.photo)
      render template: "dog_profiles/show", locals: { dog_profile: dog_profile, photo_url: photo_url }, status: :ok
    else
      render json: { errors: dog_profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def dog_profile_params
    params.require(:dog_profile).permit(:name, :breed, :age, :photo)
  end
end
