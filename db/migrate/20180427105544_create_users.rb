class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :auth0_id

      t.timestamps
    end
    add_index :users, :auth0_id, unique: true
  end
end
