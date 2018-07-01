require 'redcarpet/render_strip'

Maildown::MarkdownEngine.set_text do |text|
  Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(text).gsub("\n", "\n\n")
end