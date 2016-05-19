class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :qnt
      t.decimal :sale_value
      t.decimal :total_value

      t.timestamps null: false
    end
  end
end
