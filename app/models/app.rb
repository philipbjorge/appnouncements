class App < ApplicationRecord
  include ActiveModel::Dirty

  def self.allowed_platforms
    %w(Android)  # iOS coming soon
  end
  
  # Validation
  validates :display_name, presence: true
  validates :platform, presence: true
  validates :platform, inclusion: { in: self.allowed_platforms, message: "must be an allowed platform type" }, if: lambda {|e| not e.platform.blank? }
  validates :color, presence: true, css_hex_color: true

  # Relations
  belongs_to :user
  has_many :releases, dependent: :destroy
  has_many_attached :images

  # Callbacks
  before_save :render_css

  def release_type
    return "IosRelease" if self.ios?
    return "AndroidRelease" if self.android?
  end
  
  def ios?
    self.platform.downcase == "ios"
  end

  def android?
    self.platform.downcase == "android"
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
