class CreatePricesContractsJoinTable < ActiveRecord::Migration[6.1]
  def change
    # If you want to add an index for faster querying through this join:
    create_join_table :prices, :contracts do |t|
      t.index :price_id
      t.index :contract_id
    end
  end
end
