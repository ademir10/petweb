class AddStatusToOuttowel < ActiveRecord::Migration
  def change
    add_column :outtowels, :status, :string
  end
end
