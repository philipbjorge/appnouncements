class RemovePlanFromSubscription < ActiveRecord::Migration[5.2]
  def change
    remove_column :subscriptions, :plan
  end
end
