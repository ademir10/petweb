json.array!(@outtowels) do |outtowel|
  json.extract! outtowel, :id, :client_id
  json.url outtowel_url(outtowel, format: :json)
end
