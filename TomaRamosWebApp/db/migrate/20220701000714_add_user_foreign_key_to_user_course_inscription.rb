class AddUserForeignKeyToUserCourseInscription < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_course_inscriptions, :user, null: false, foreign_key: true
  end
end
