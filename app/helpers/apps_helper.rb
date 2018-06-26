module AppsHelper
  def format_version release
    return release.version if release.app.ios?
    return "#{release.display_version} / #{release.version}" if release.app.android?
  end

  def format_platform app
    return "iOS" if app.ios?
    return "Android" if app.android?
    return "Unknown"
  end
end