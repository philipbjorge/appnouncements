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
    [:core]  # todo: ios
  end
  
  # Validation
  validates :display_name, presence: true
  validates :platform, presence: true
  validates :platform, inclusion: { in: self.allowed_platforms, message: "must be an allowed platform type" }, if: lambda {|e| not e.platform.blank? }
  validates :color, presence: true, css_hex_color: true
  validates :plan, presence: true
  validates :plan, inclusion: { in: self.allowed_plans, message: "must specify a plan" }, if: lambda {|e| not e.plan.blank? }

  # Relations
  belongs_to :user
  has_many :releases, dependent: :destroy
  has_many_attached :images

  # Callbacks
  before_save :render_css
  
  attribute :plan, :string, default: self.allowed_plans.first

  def platform
    super.to_sym unless super.nil?
  end
  
  def plan
    super.to_sym unless super.nil?
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
