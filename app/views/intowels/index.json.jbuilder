json.array!(@intowels) do |intowel|
  json.extract! intowel, :id, :client_id, :form_receipt, :installments, :status
  json.url intowel_url(intowel, format: :json)
end
