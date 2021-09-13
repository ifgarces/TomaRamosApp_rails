class CreateRamos < ActiveRecord::Migration[6.1]
  def change
    create_table :ramos do |t|
      t.string :nombre
      t.string :profesor
      t.integer :creditos
      t.string :materia
      t.integer :curso
      t.string :seccion
      t.string :plan_estudios
      t.string :connector_liga
      t.string :lista_cruzada

      t.timestamps
    end
  end
end
