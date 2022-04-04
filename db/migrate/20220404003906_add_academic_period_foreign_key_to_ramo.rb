class AddAcademicPeriodForeignKeyToRamo < ActiveRecord::Migration[7.0]
  def change
    add_reference :ramos, :academic_period, null: false, foreign_key: true
  end
end
