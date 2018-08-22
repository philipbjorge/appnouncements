class ApplicationMailer::MailerPreview < ActionMailer::Preview
  def missing_release
    app = User.first.apps.where(platform: "android").first
    ApplicationMailer.with(user: User.first, app: app, release: app.releases.first).missing_release
  end
end