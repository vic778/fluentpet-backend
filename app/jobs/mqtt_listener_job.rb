class MqttListenerJob < ApplicationJob
  queue_as :default

  def perform
    # Connect to the local Mosquitto broker
    MQTT::Client.connect("mqtt://localhost:1883") do |client|
      # Subscribe to the topic
      client.get("fluentpet/button_events") do |topic, message|
        event_data = JSON.parse(message)
        # Save the button event to the database
        ButtonEvent.create(event_data)
      end
    end
  end
end
