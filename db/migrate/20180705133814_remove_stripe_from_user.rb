class RemoveStripeFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :stripe_id
    remove_column :users, :stripe_customer
  end
end
