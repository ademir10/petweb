class AddValueDocToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :value_doc, :decimal
  end
end
