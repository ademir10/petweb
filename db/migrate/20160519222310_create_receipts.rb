class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :doc_number
      t.string :type_doc
      t.references :client, index: true, foreign_key: true
      t.string :description
      t.date :due_date
      t.date :receipt_date
      t.integer :installments
      t.string :form_receipt
      t.string :status
      t.integer :invoice_id

      t.timestamps null: false
    end
  end
end
