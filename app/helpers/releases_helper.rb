module ReleasesHelper
  def device_class(app)
    return "device-iphone-8 device-spacegray" if app.ios?
    return "device-google-pixel device-black"
  end
end
