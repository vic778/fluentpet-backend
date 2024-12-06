class DogProfilesController < ApplicationController
  def create
    dog_profile = DogProfile.new(dog_profile_params)

    if dog_profile.save
      photo_url = url_for(dog_profile.photo)
      render "dog_profiles/show.json.jbuilder", locals: { dog_profile: dog_profile, photo_url: photo_url }
    else
      render json: { errors: dog_profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def dog_profile_params
    params.require(:dog_profile).permit(:name, :breed, :age, :photo)
  end
end
