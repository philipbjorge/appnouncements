class Auth0Required < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :auth0_id, false, "garbage id"
  end
end
