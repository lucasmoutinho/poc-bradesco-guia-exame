class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices do |t|
      t.string :name
      t.string :code
      t.string :value

      t.timestamps
    end
    add_index :prices, :name
  end
end
