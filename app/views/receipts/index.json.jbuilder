json.array!(@receipts) do |receipt|
  json.extract! receipt, :id, :doc_number, :type_doc, :client_id, :description, :due_date, :receipt_date, :installments, :form_receipt, :status, :invoice_id
  json.url receipt_url(receipt, format: :json)
end
