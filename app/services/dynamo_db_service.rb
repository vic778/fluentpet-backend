require "aws-sdk-dynamodb"

class DynamoDbService
  BUTTON_EVENTS_TABLE = "button_events"
  AUDIO_FILES_TABLE = "audio_files"

  def initialize
    @client = Aws::DynamoDB::Client.new(region: ENV["AWS_REGION"])
  end

  def save_button_event(button_id:, timestamp:, event_type:)
    @client.put_item(
      table_name: BUTTON_EVENTS_TABLE,
      item: {
        button_id: button_id,
        timestamp: timestamp,
        event_type: event_type
      }
    )
  end

  def save_audio_file(button_id:, timestamp:, audio_url:, duration:)
    @client.put_item(
      table_name: AUDIO_FILES_TABLE,
      item: {
        button_id: button_id,
        timestamp: timestamp,
        audio_url: audio_url,
        duration: duration
      }
    )
  end
end
