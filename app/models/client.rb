class Client < ActiveRecord::Base
  belongs_to :cidade
  belongs_to :estado
  has_many :prod_clis
  
  validates :company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :nf, presence: true
  validates :company, uniqueness: true
end
