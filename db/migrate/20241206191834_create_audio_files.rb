class CreateAudioFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :audio_files do |t|
      t.string :button_id
      t.datetime :timestamp
      t.integer :duration
      t.jsonb :metadata

      t.timestamps
    end
  end
end
