class Receipt < ActiveRecord::Base
  belongs_to :client
  
    validates :type_doc, :description, :due_date, :installments, :value_doc, :client_id, :status,
  presence: true
end
