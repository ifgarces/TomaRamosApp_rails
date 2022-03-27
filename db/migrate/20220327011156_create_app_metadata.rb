class CreateAppMetadata < ActiveRecord::Migration[7.0]
  def change
    create_table :app_metadata do |t|
      t.string :latest_version_name, limit: 100
      t.string :catalog_current_period
      t.string :catalog_last_updated

      t.timestamps
    end
  end
end
