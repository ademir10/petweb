class CreateIntowels < ActiveRecord::Migration
  def change
    create_table :intowels do |t|
      t.references :client, index: true, foreign_key: true
      t.string :form_receipt
      t.integer :installments
      t.string :status

      t.timestamps null: false
    end
  end
end
