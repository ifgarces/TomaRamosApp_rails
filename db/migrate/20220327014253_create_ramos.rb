class CreateRamos < ActiveRecord::Migration[7.0]
  def change
    create_table :ramos do |t|
      t.string :name, limit: 100
      t.string :profesor, limit: 100
      t.integer :creditos
      t.string :materia, limit: 30
      t.integer :curso
      t.string :seccion, limit: 30
      t.string :plan_estudios, limit: 30
      t.string :conect_liga, limit: 30
      t.string :lista_cruzada, limit: 30

      t.timestamps
    end
  end
end
