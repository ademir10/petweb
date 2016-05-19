class AddIntowelToItem < ActiveRecord::Migration
  def change
    add_reference :items, :intowel, index: true, foreign_key: true
  end
end
