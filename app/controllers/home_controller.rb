class HomeController < ApplicationController
  def index
     render json: { message: "Welcome to FluentPet Backend Project, for futher details, please reach out to the developer",
                   email: "barhvictor@gmail.com", github: "https://github.com/vic778", linkdin: "https://www.linkedin.com/in/victor-barh/" }, status: :ok
  end
end
