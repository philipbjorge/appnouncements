class PrismApp
  def apps
    AppsPage.new
  end
  
  def new_app
    NewAppPage.new
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
  
  def edit_app
    EditAppPage.new
  end
  
  def edit_android_release
    EditAndroidReleasePage.new
  end
end