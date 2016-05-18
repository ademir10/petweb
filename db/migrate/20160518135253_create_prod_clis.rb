class CreateProdClis < ActiveRecord::Migration
  def change
    create_table :prod_clis do |t|
      t.references :client, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.integer :qnt
      t.decimal :val1
      t.decimal :val2
      t.decimal :val3
      t.decimal :val4
      t.decimal :val5

      t.timestamps null: false
    end
  end
end
