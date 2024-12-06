require "aws-sdk-dynamodb"

class ButtonEventService
  TABLE_NAME = "button_events"

  def initialize
    @client = Aws::DynamoDB::Client.new(region: ENV["AWS_REGION"])
  end

  def save_event(button_id:, timestamp:, event_type:)
    @client.put_item(
      table_name: TABLE_NAME,
      item: {
        button_id: button_id,
        timestamp: timestamp,
        event_type: event_type
      }
    )
  end
end
