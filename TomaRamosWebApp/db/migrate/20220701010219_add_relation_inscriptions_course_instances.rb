class AddRelationInscriptionsCourseInstances < ActiveRecord::Migration[7.0]
  def change
    create_table :course_instances_inscriptions, id: false do |t|
      t.belongs_to :inscription
      t.belongs_to :course_instance
    end
  end
end
