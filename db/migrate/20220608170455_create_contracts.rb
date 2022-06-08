class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :provider, null: false, foreign_key: true
      t.string :contract_type

      t.timestamps
    end
  end
end
