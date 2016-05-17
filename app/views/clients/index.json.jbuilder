json.array!(@clients) do |client|
  json.extract! client, :id, :company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :nf, :val1, :val2, :val3, :val4, :val5
  json.url client_url(client, format: :json)
end
