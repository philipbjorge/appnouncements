class AddPlanToApps < ActiveRecord::Migration[5.2]
  def change
    add_column :apps, :plan, :string
  end
end
