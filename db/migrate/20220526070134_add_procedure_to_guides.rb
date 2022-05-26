class AddProcedureToGuides < ActiveRecord::Migration[6.1]
  def change
    add_reference :procedures, :guide
  end
end
