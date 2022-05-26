class CreateProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.string :code
      t.string :name
      t.string :profile

      t.timestamps
    end
    add_index :procedures, :code
  end
end
