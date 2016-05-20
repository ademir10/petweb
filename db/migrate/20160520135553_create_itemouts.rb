class CreateItemouts < ActiveRecord::Migration
  def change
    create_table :itemouts do |t|
      t.references :product, index: true, foreign_key: true
      t.integer :qnt
      t.references :outtowel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
