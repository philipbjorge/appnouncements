module AppsHelper
  def format_version release
    return release.display_version if release.app.platform == "ios"
    return "#{release.display_version} / #{release.version}" if release.app.platform == "android"
  end

  def format_platform app
    return "" unless app.platform
    
    return "iOS" if app.platform == "ios"
    return app.platform.titlecase
  end
end