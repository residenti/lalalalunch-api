class AddUseridToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :userid, :string, null: false
    add_index :users, :userid, unique: true
  end
end
