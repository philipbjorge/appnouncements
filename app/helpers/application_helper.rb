module ApplicationHelper
  def alert_class_for(flash_type)
    mapping = {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-primary'
    }
    mapping[flash_type.to_sym] || "alert-#{flash_type.to_s}"
  end

  def render_markdown(md)
    p = HTML::Pipeline.new [MarkdownFilter,
                            OneboxFilter,
                            LozadFilter,
                            HTML::Pipeline::ImageMaxWidthFilter], {}
    p.call(md)[:output].to_s.html_safe
  end

  class MarkdownFilter < HTML::Pipeline::TextFilter
    def initialize(text, context = nil, result = nil)
      super text, context, result
      @text = @text.delete "\r"
    end

    def call
      renderer = Redcarpet::Render::HTML.new(
          filter_html: true, no_images: false, no_links: false, no_styles: true, safe_links_only: true,
          with_toc_data: true, hard_wrap: true
      )

      Redcarpet::Markdown.new(renderer,
                              no_intra_emphasis: false, tables: true, fenced_code_blocks: true,
                              autolink: true, disable_indented_code_blocks: true, strikethrough: true, lax_spacing: true,
                              space_after_headers: false, superscript: true, underline: true, highlight: true, quote: false,
                              footnotes: false
      ).render(@text)
    end
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
        link.include? "youtube.com/" or
        link.include? "youtu.be/"
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
end
