class AddChargebeeIdIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :chargebee_id, unique: true
    add_index :subscriptions, :chargebee_id, unique: true
  end
end
