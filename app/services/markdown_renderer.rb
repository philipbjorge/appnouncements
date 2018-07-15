class MarkdownRenderer
  def initialize md
    @md = md
  end
  
  def render_markdown_unsafe
    p = HTML::Pipeline.new [UnsafeMarkdownFilter,
                            OneboxFilter,
                            HTML::Pipeline::ImageMaxWidthFilter], {}
    p.call(@md)[:output].to_s.html_safe
  end
  
  def render_markdown
    p = HTML::Pipeline.new [MarkdownFilter,
                            OneboxFilter,
                            HTML::Pipeline::ImageMaxWidthFilter], {}
    p.call(@md)[:output].to_s.html_safe
  end
  
  def render_markdown_lazy
    p = HTML::Pipeline.new [MarkdownFilter,
                            OneboxFilter,
                            LozadFilter,
                            HTML::Pipeline::ImageMaxWidthFilter], {}
    p.call(@md)[:output].to_s.html_safe
  end
end

class UnsafeMarkdownFilter < HTML::Pipeline::TextFilter
  def initialize(text, context = nil, result = nil)
    super text, context, result
    @text = @text.delete "\r"
  end

  def call
    render_markdown(@text, false)
  end
end

class MarkdownFilter < HTML::Pipeline::TextFilter
  def initialize(text, context = nil, result = nil)
    super text, context, result
    @text = @text.delete "\r"
  end

  def call
    render_markdown(@text, true)
  end
end

def render_markdown text, safe
  renderer = Redcarpet::Render::HTML.new(
      filter_html: safe, no_images: false, no_links: false, no_styles: true, safe_links_only: true,
      with_toc_data: true, hard_wrap: true
  )

  Redcarpet::Markdown.new(renderer,
                          no_intra_emphasis: false, tables: true, fenced_code_blocks: true,
                          autolink: true, disable_indented_code_blocks: true, strikethrough: true, lax_spacing: true,
                          space_after_headers: false, superscript: true, underline: true, highlight: true, quote: false,
                          footnotes: false
  ).render(text)
end

class OneboxFilter < HTML::Pipeline::Filter
  def call
    doc.search('a').each do |node|
      next unless should_onebox? node["href"]
      node.replace('<div class="video-responsive">' + Onebox.preview(node["href"]).to_s + "</div>")
    end

    doc
  end

  def should_onebox? link
    return (
      link.include?("youtube.com/") || link.include?("youtu.be/")
    )
  end
end

class LozadFilter < HTML::Pipeline::Filter
  def call
    iframes = doc.search('iframe')

    iframes.add_class "lozad"
    iframes.each do |node|
      node["data-src"] = node["src"]
      node.delete("src")
    end

    doc
  end
end