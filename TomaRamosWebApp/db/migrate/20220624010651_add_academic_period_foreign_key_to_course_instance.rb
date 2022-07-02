class AddAcademicPeriodForeignKeyToCourseInstance < ActiveRecord::Migration[7.0]
  def change
    add_reference :course_instances, :academic_period, null: false, foreign_key: true
  end
end
