class AddEventTypeForeignKeyToCourseEvent < ActiveRecord::Migration[7.0]
  def change
    add_reference :course_events, :event_type, null: false, foreign_key: true
  end
end
