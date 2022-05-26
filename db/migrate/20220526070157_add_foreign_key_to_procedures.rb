class AddForeignKeyToProcedures < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :procedures, :guides
  end
end
