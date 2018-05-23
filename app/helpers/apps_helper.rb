module AppsHelper
  def format_version release
    return release.display_version if release.app.platform == "ios"
    return "#{release.display_version} / #{release.version}" if release.app.platform == "android"
  end
end