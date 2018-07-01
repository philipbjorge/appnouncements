class AppsPage < SitePrism::Page
  set_url "/apps"

  section :no_apps_card, "#no-apps-card", text: "You don't have any apps" do
    element :new_app_btn, "#new-app-btn"
  end
  
  section :toolbar, "#apps-toolbar" do
    element :new_app_btn, "#new-app-btn"
  end
end

class NewAppPage < SitePrism::Page
  set_url "/apps/new"
  
  fields :platform, :display_name, :color
  submit_button

  submission :new_app
end

class AppDetailsPage < SitePrism::Page
  set_url "/apps{/app_id}"

  section :no_releases_card, "#no-releases-card", text: "You don't have any releases" do
    element :new_release_btn, "#new-release-btn"
  end

  section :toolbar, "#releases-toolbar" do
    element :new_release_btn, "#new-release-btn"
  end
end