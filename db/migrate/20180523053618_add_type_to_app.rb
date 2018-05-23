class AddTypeToApp < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :platform, :string
  end
end
