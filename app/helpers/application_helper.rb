module ApplicationHelper
  def toast_class_for(flash_type)
    mapping = {
      success: 'toast-success',
      error: 'toast-error',
      alert: 'toast-warning',
      notice: 'toast-primary'
    }
    mapping[flash_type.to_sym] || flash_type.to_s
  end

  def render_markdown(md)
    renderer = FancyMarkdownRenderer.new(
        filter_html: true, no_images: false, no_links: false, no_styles: true, safe_links_only: true,
        with_toc_data: true, hard_wrap: true
    )
    Redcarpet::Markdown.new(renderer,
                            no_intra_emphasis: false, tables: true, fenced_code_blocks: true,
                            autolink: true, disable_indented_code_blocks: true, strikethrough: true, lax_spacing: true,
                            space_after_headers: false, superscript: true, underline: true, highlight: true, quote: false,
                            footnotes: false
    ).render(md).html_safe
  end

  class FancyMarkdownRenderer < Redcarpet::Render::HTML
    def image(link, title, alt_text)
      %(<img class="img-responsive" src="#{link}" title="#{title}" alt="#{alt_text}" />)
    end

    def autolink(link, link_type)
      return responsive_video(link) if should_parse_video(link)
      %(<a href="#{link}">#{link}</a>)
    end

    def link(link, title, content)
      return responsive_video(link) if should_parse_video(link)
      %(<a href="#{link}" title="#{title}">#{content}</a>)
    end

  private
    def should_parse_video link
      return (
        link.include? "youtube.com/" or
        link.include? "youtu.be/" or
        link.include? "vimeo.com/"
      )
    end

    def responsive_video link
      '<div class="video-responsive">' + Onebox.preview(link).to_s + '</div>'
    end
  end
end
