class CreateCourseInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :course_instances do |t|
      t.string :nrc, limit: 16
      t.string :title, limit: 128
      t.string :teacher, limit: 128
      t.integer :credits
      t.string :career, limit: 16
      t.integer :course_number
      t.integer :section
      t.string :curriculum, limit: 16
      t.string :liga, limit: 32
      t.string :lcruz, limit: 32

      t.timestamps
    end
  end
end
