class CreateReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :releases do |t|
      t.string :version, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.references :app, foreign_key: true

      t.timestamps
    end
  end
end
