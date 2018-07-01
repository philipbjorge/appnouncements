class PrismApp
  def apps
    AppsPage.new
  end
  
  def new_app
    NewAppPage.new
  end
  
  def app_details
    AppDetailsPage.new
  end
end