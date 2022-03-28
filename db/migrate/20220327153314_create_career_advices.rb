class CreateCareerAdvices < ActiveRecord::Migration[7.0]
  def change
    create_table :career_advices do |t|
      t.string :title, limit: 60
      t.text :description
      t.string :url, limit: 200

      t.timestamps
    end
  end
end
