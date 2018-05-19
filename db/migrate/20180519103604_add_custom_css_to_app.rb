class AddCustomCssToApp < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :css, :string
  end
end
