class CreateCourseEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :course_events do |t|
      t.string :location, limit: 32, null: true
      t.string :day_of_week, limit: 16, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.date :date, null: true

      t.timestamps
    end
  end
end
