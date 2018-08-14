# == Schema Information
#
# Table name: plans
#
#  id           :bigint(8)        not null, primary key
#  metadata     :json             not null
#  name         :string           not null
#  price        :integer          not null
#  status       :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chargebee_id :string           not null
#

class Plan < ApplicationRecord
  METADATA_JSON_SCHEMA = Rails.root.join('config', 'schemas', 'plan_metadata.json').to_s
  
  validates :chargebee_id, presence: true
  validates :name, presence: true
  validates :price, presence: true
  validates :status, presence: true
  validates :metadata, presence: true, json: { schema: METADATA_JSON_SCHEMA, message: ->(errors) { errors } }
  
  def self.create_or_update_from_chargebee!(chargebee_id)
    plan = ChargeBee::Plan.retrieve(chargebee_id).plan
    
    p = Plan.find_or_initialize_by(chargebee_id: chargebee_id)
    p.metadata = plan.meta_data || {}
    p.name = plan.invoice_name || plan.name
    p.price = plan.price
    p.status = plan.status
    p.save!
  end
  
  def can_create_new_app?
    return (user.apps.count + 1) <= app_limit
  end

  def show_branding?
    self.metadata["features"]["branding"]
  end
  
  def allow_theming?
    self.metadata["features"]["theming"]
  end

  def app_limit
    return Float::INFINITY if self.metadata["features"]["app_limit"].nil?
    return self.metadata["features"]["app_limit"]
  end
end
