class CreateProceduresGuidesJoinTable < ActiveRecord::Migration[6.1]
  def change
    # If you want to add an index for faster querying through this join:
    create_join_table :procedures, :guides do |t|
      t.index :procedure_id
      t.index :guide_id
    end
  end
end
