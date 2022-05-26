class CreatePatients < ActiveRecord::Migration[6.1]
  def change
    create_table :patients do |t|
      t.string :cpf
      t.string :name

      t.timestamps
    end
    add_index :patients, :cpf
  end
end
