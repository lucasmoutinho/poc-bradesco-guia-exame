class CreateGuides < ActiveRecord::Migration[6.1]
  def change
    create_table :guides do |t|
      t.references :provider, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.string :value
      t.string :detail

      t.timestamps
    end
  end
end
