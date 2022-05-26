class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers do |t|
      t.string :code
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :providers, :code
  end
end
