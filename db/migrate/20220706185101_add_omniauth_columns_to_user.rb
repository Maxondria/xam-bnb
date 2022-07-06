class AddOmniauthColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :auth_id, :string
    add_column :users, :name, :string, null: false

    add_index :users, :auth_id
    add_index :users, %i[provider auth_id]
  end
end
