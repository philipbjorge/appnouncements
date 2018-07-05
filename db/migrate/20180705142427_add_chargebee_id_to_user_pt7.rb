class AddChargebeeIdToUserPt7 < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :chargebee_id, :string
  end
end
