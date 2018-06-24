class AddDisabledFlagToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :disabled, :boolean, default: false
  end
end
