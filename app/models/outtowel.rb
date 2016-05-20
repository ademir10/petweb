class Outtowel < ActiveRecord::Base
  belongs_to :client
  
  # para poder permitir a exclusão da invoice mesmo tendo itens ou não
  has_many :itemouts, dependent: :destroy
  
  validates :client_id, presence: true
end
