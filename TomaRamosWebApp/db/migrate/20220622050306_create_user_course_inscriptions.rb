class CreateUserCourseInscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_course_inscriptions do |t|
      t.timestamps
    end
  end
end
