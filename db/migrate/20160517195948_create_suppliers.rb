class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
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
      t.string :bank
      t.string :agency
      t.string :acount
      t.string :favored
      

      t.timestamps null: false
    end
  end
end
