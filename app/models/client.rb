class Client < ActiveRecord::Base
  belongs_to :cidade
  belongs_to :estado
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :prod_clis, dependent: :destroy
  
  validates :company, :name, :address, :neighborhood, :cidade_id, :estado_id, :cep, :phone, :cellphone, :email, :cnpj, :nf, presence: true
  validates :company, uniqueness: true
end
