module ValidFeedback
  def valid_feedback(wrapper_options = nil)
    return nil if options[:valid_feedback] === false
    template.content_tag(:div, (options[:valid_feedback] || "Looks Good!"), class: "valid-feedback")
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(ValidFeedback)