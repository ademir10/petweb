class AddQntTowelToClients < ActiveRecord::Migration
  def change
    add_column :clients, :qnt, :integer
  end
end
