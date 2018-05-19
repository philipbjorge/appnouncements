class AddColorToApp < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :color, :string, default: "#727e96"
  end
end
