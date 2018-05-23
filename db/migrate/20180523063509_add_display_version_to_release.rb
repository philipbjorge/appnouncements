class AddDisplayVersionToRelease < ActiveRecord::Migration[5.2]
  def change
    add_column :releases, :display_version, :string
  end
end
