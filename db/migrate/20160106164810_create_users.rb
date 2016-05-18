class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :type_access
      
      t.boolean :ccli
      t.boolean :csuplier
      t.boolean :cprod
      t.boolean :cuser
      
      t.boolean :min
      t.boolean :mout
      t.boolean :mlog
     
      t.boolean :fpag
      t.boolean :frec
      t.boolean :rcli
      t.boolean :rsuplier
      t.boolean :rprod
      t.boolean :rpag
      t.boolean :rrec
      t.boolean :rsale
            
      t.timestamps null: false
    end
  end
end
