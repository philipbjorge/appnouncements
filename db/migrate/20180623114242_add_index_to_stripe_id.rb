class AddIndexToStripeId < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :stripe_id, unique: true
  end
end
