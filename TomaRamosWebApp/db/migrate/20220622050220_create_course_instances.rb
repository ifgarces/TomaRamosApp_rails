class CreateCourseInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :course_instances do |t|
      t.string :nrc, limit: 16, null: false
      t.string :title, limit: 128, null: false
      t.string :teacher, limit: 128, null: false
      t.integer :credits, null: false
      t.string :career, limit: 16, null: false
      t.integer :course_number, null: false
      t.integer :section, null: false
      t.string :curriculum, limit: 16, null: false

      t.string :liga, limit: 32, null: true
      t.string :lcruz, limit: 32, null: true

      t.timestamps
    end
  end
end
