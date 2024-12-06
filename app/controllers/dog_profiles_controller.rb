class DogProfilesController < ApplicationController
  def create
    dog_profile = DogProfile.new(dog_profile_params)

    if dog_profile.save
      photo_url = url_for(dog_profile.photo)
      render json: { id: dog_profile.id, photo_url: }, status: :created
    else
      render json: { errors: dog_profile.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def dog_profile_params
    params.require(:dog_profile).permit(:name, :breed, :age, :photo)
  end
end
