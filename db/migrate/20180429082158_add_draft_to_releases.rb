class AddDraftToReleases < ActiveRecord::Migration[5.2]
  def change
    add_column :releases, :draft, :boolean, default: true
  end
end
