class Supplier < ActiveRecord::Base
  belongs_to :cidade
  belongs_to :estado
  
  validates :company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :bank, :agency, :acount, :favored,
  presence: true
  validates :company, uniqueness: true
end
