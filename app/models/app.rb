class App < ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :user
  has_many :releases

  before_save :render_css

  private
  def render_css
    if css.nil? or color_changed?
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
