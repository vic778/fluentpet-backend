class ButtonEventsController < ApplicationController
  def create
    service = DynamoDbService.new
    service.save_button_event(
      button_id: params[:button_id],
      timestamp: params[:timestamp],
      event_type: params[:event_type]
    )

    cache_events(params)
    render json: { message: "Event saved" }, status: :ok
  end

  protected

  def cache_events(data)
    event_data = {
      button_id: data[:button_id],
      event_type: data[:event_type],
      timestamp: Time.now.utc.to_s
    }

    key = "latest_events:#{event_data[:button_id]}"

    # Check if the key exists and is of the wrong type
    if $redis.exists(key) && $redis.type(key) != "zset"
      $redis.del(key)
    end
    $redis.zadd(key, event_data[:timestamp].to_i, event_data.to_json)
    $redis.expire(key, 24.hours.to_i)

    # Keep only the latest 10 events
    $redis.zremrangebyrank(key, 0, -11)
  end
end
