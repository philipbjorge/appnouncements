class AddUuidToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :uuid, :uuid, default: 'gen_random_uuid()'
    add_index :apps, :uuid, unique: true
  end
end
