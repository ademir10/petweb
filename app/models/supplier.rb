class Supplier < ActiveRecord::Base
  belongs_to :cidade
  belongs_to :estado
end