class CreateEventTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :event_types do |t|
      t.string :name, limit: 32, null: false

      t.timestamps
    end
  end
end
