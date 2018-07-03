# == Schema Information
#
# Table name: apps
#
#  id           :bigint(8)        not null, primary key
#  color        :string           default("#727e96")
#  css          :string
#  disabled     :boolean          default(FALSE)
#  display_name :string
#  plan         :string
#  platform     :string
#  uuid         :uuid
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint(8)
#
# Indexes
#
#  index_apps_on_user_id  (user_id)
#  index_apps_on_uuid     (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class App < ApplicationRecord
  include ActiveModel::Dirty

  def self.allowed_platforms
    [:android]  # todo: ios
  end
  
  def self.allowed_plans
    [:core]  # todo: pro
  end

  def self.plans_to_id
    {core: "plan_D6LP7fkX00U1Tm", pro: "plan_D6LQ51tBxhzCFI"}
  end
  
  # Validation
  validates :display_name, presence: true
  validates :platform, presence: true
  validates :platform, inclusion: { in: self.allowed_platforms, message: "must be an allowed platform type" }, if: lambda {|e| not e.platform.blank? }
  validates :color, presence: true, css_hex_color: true
  validates :plan, presence: true
  validates :plan, inclusion: { in: self.allowed_plans, message: "must specify a plan" }, if: lambda {|e| not e.plan.blank? }
  validates_acceptance_of :billing_changes_confirmed, on: [:create, :update]
  
  # Relations
  belongs_to :user
  has_many :releases, dependent: :destroy
  has_many_attached :images

  # Callbacks
  before_save :render_css
  before_save :update_subscription
  after_destroy :update_subscription

  def platform
    super.to_sym unless super.nil?
  end
  
  def plan
    return super.to_sym unless super.nil?
    return App.allowed_plans.first
  end
  
  def release_type
    return "IosRelease" if self.ios?
    return "AndroidRelease" if self.android?
  end
  
  def ios?
    self.platform == :ios
  end

  def android?
    self.platform == :android
  end

  private
  def update_subscription
    if (will_save_change_to_plan? || will_save_change_to_disabled? || destroyed?) && (self.user.apps.length > 1 || self.plan != :core)
      if self.user.customer.subscriptions.data.length == 0
        Stripe::Subscription.create(customer: self.user.customer.id, items: [
            {plan: App.plans_to_id[:core], quantity: [0, self.user.apps.select { |a| a.plan == :core && !a.disabled}.length - 1].max},
            {plan: App.plans_to_id[:pro], quantity: self.user.apps.select { |a| a.plan == :pro && !a.disabled}.length}
        ])
      else
        self.user.customer.subscriptions.data[0].items.data.each do |i|
          original_quantity = i.quantity
          i.quantity = self.user.apps.select {|a| App.plans_to_id[a.plan] == i.plan.id && !a.disabled }.length
          i.quantity = [0, i.quantity - 1].max if i.plan.id == App.plans_to_id[:core]
          i.save if i.quantity != original_quantity
        end
      # TODO: if subscription count == 0, cancel?
      end
    end
  end
  
  def render_css
    if css.nil? or will_save_change_to_color?
      # TODO: Optimize our imports
      template = <<-eos
        $primary-color: #{self.color};
        @import 'app/assets/stylesheets/webview'
      eos
      engine = ::Sass::Engine.new(template, {style: :compressed, syntax: :scss, load_paths: [Rails.root], cache_location: "./tmp/sass-cache"})
      self.css = engine.render
    end
  end
end
