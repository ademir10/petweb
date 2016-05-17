class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :company
      t.string :name
      t.string :address
      t.string :neighborhood
      t.references :cidade, index: true, foreign_key: true
      t.references :estado, index: true, foreign_key: true
      t.string :cep
      t.string :phone
      t.string :cellphone
      t.string :email
      t.string :cnpj
      t.string :nf
      t.decimal :val1
      t.decimal :val2
      t.decimal :val3
      t.decimal :val4
      t.decimal :val5

      t.timestamps null: false
    end
  end
end
