class CreateCourseEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :course_events do |t|
      t.string :location, limit: 32
      t.string :day_of_week, limit: 16
      t.time :start_time
      t.time :end_time
      t.date :date

      t.timestamps
    end
  end
end
