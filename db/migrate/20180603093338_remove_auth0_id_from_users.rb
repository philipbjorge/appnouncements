class RemoveAuth0IdFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, name: "index_users_on_auth0_id"
    remove_column :users, :auth0_id
  end
end
