class CreateRamos < ActiveRecord::Migration[7.0]
  def change
    create_table :ramos, :id => false do |t|
      t.string :nrc, limit: 30, primary_key: true
      t.string :name, limit: 100
      t.string :profesor, limit: 100
      t.integer :creditos
      t.string :materia, limit: 60
      t.integer :curso
      t.string :seccion, limit: 60
      t.string :plan_estudios, limit: 60
      t.string :conect_liga, limit: 60
      t.string :lista_cruzada, limit: 60

      t.timestamps
    end
  end
end
