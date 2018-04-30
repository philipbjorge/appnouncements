class BooleanInput < SimpleForm::Inputs::BooleanInput
  def label_text
    '<i class="form-icon"></i>'.html_safe + super
  end
end