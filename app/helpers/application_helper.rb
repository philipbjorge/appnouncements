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
end
