class AddRfechaToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rfecha, :boolean
  end
end
