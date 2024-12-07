class CreateButtonEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :button_events do |t|
      t.string :button_id
      t.datetime :timestamp
      t.string :event_type

      t.timestamps
    end
  end
end
