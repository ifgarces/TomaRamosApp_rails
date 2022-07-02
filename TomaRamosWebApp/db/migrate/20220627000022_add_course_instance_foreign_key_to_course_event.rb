class AddCourseInstanceForeignKeyToCourseEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :course_events, :course_instance, null: false, foreign_key: true
  end
end
