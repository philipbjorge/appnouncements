module ApplicationHelper
  def bootstrap_alert_class_for(flash_type)
    {success: "alert-success",
     error: "alert-danger",
     alert: "alert-warning",
     notice: "alert-info"
    }[flash_type.to_sym] || "alert-#{flash_type.to_s}"
  end
  
  def add_bootstrap_alert_link(msg)
    fragment = Nokogiri::HTML.fragment(msg)
    fragment.search("a").add_class("alert-link")
    fragment.to_s.html_safe
  end
  
  def render_markdown_unsafe(md)
    MarkdownRenderer.new(md).render_markdown_unsafe.html_safe
  end
  
  def render_markdown_lazy(md)
    MarkdownRenderer.new(md).render_markdown_lazy.html_safe
  end
end
