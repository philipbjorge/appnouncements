class PrismApp
  def apps
    AppsPage.new
  end
  
  def new_app(free:false)
    free ? FreeNewAppPage.new : NewAppPage.new
  end
  
  def new_android_release
    NewAndroidReleasePage.new
  end
  
  def app_details
    AppDetailsPage.new
  end
  
  def sdk_integration
    SDKIntegrationPage.new
  end
  
  def edit_app(free:false)
    free ? FreeEditAppPage.new : EditAppPage.new
  end
  
  def edit_android_release
    EditAndroidReleasePage.new
  end
end