class AddMacertoToUser < ActiveRecord::Migration
  def change
    add_column :users, :macerto, :boolean
  end
end
