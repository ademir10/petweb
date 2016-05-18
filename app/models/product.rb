class Product < ActiveRecord::Base
  belongs_to :prod_cli
  
  validates :name, presence: true
  validates :name, uniqueness: true
  
end
