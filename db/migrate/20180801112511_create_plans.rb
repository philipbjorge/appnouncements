class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :chargebee_id, null: false, unique: true
      t.string :name, null: false
      t.integer :price, null: false
      t.string :status, null: false
      t.json :metadata, null: false

      t.timestamps
    end
  end
end
