class Payment < ActiveRecord::Base
  belongs_to :supplier
  
    validates :description, :due_date, :installments, :value_doc, :supplier_id, :status,
  presence: true
end
