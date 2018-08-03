class ErrorController < ApplicationController
  skip_after_action :verify_authorized
  layout false
  
  def error_404
    render(:status => 404)
  end

  def error_422
    render(:status => 422)
  end
  
  def error_500
    @sentry_event_id = Raven.last_event_id
    render(:status => 500)
  end
end