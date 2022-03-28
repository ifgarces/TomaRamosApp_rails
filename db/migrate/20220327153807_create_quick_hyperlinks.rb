class CreateQuickHyperlinks < ActiveRecord::Migration[7.0]
  def change
    create_table :quick_hyperlinks do |t|
      t.string :name, limit: 60
      t.string :url, limit: 200

      t.timestamps
    end
  end
end
