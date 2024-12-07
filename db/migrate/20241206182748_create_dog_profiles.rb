class CreateDogProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :dog_profiles do |t|
      t.string :name
      t.string :breed
      t.integer :age
      t.jsonb :metadata

      t.timestamps
    end
  end
end
