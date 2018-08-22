class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@appnouncements.com'
  layout 'mailer'
  
  def missing_release
    @user = params[:user]
    @app = params[:app]
    @release = params[:release]
    mail(to: @user.email, subject: "Missing release version #{@release.version} for #{@app.display_name}")
  end
end
