class ButtonEventsController < ApplicationController
  def create
    service = DynamoDbService.new
    service.save_event(
      button_id: params[:button_id],
      timestamp: params[:timestamp],
      event_type: params[:event_type]
    )

    render json: { message: "Event saved" }, status: :ok # if service.success
  end
end
