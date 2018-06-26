class CreateReleasesDoOver < ActiveRecord::Migration[5.2]
  def up
    drop_table :releases
    create_table :releases do |t|
      t.string :type, null: false
      t.timestamps
      
      t.string :title, null: false
      t.text :body, null: false
      t.references :app, foreign_key: true
      t.boolean :published, default: false
      
      t.string :version, null: false  # required
      t.string :display_version       # can be null and we fallback to version (e.g. iOS)
    end
  end
end
