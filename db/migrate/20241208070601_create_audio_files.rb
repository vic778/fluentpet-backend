class CreateAudioFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :audio_files do |t|
      t.integer :duration
      t.datetime :timestamp
      t.jsonb :metadata
      t.references :button_event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
