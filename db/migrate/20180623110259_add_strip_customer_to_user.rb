class AddStripCustomerToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_customer, :json
  end
end
