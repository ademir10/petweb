class ChangeColumnNameToReceipts < ActiveRecord::Migration
  def change
    rename_column :receipts, :invoice_id, :intowel_id
  end
end
