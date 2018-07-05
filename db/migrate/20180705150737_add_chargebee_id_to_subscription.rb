class AddChargebeeIdToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :chargebee_id, :string
  end
end
