require 'rails_helper'

RSpec.feature "Apps", type: :feature do
  fixtures :users, :subscriptions, :plans, :apps
  let(:appnouncements) { PrismApp.new }

  before do
    login_as(user, :scope => :user)
  end
  
  context "free user" do
    let (:user) { users(:free) }
    let (:app) { user.apps.where(platform: :android).first }  # can make shared examples
    
    scenario "cannot create a new app" do
      appnouncements.apps.load

      expect(appnouncements.apps).to be_displayed
      expect(appnouncements.apps).to have_apps
      
      # New App Disabled
      appnouncements.apps.toolbar.new_app_btn.click
      expect(appnouncements.apps.flash_messages[0]).to have_content("You must upgrade your subscription to add more apps!")
    end

    scenario "can list apps" do
      appnouncements.apps.load

      # OOBE/No Cards View
      expect(appnouncements.apps).to be_displayed

      expect(appnouncements.apps).to have_toolbar
      expect(appnouncements.apps.toolbar).to have_new_app_btn
      expect(appnouncements.apps).to_not have_no_apps_card
      expect(appnouncements.apps).to have_apps(count: 1)

      expect(appnouncements.apps.apps[0].title).to have_content(app.display_name)
      expect(appnouncements.apps.apps[0].platform).to have_content("Android")
      appnouncements.apps.apps[0].view_releases_btn.click
      
      expect(appnouncements.app_details).to be_displayed
    end
    
    scenario "can see SDK integration" do
      appnouncements.sdk_integration.load(app_id: app.id)
      expect(appnouncements.sdk_integration).to be_displayed
      expect(appnouncements.sdk_integration.title).to have_content(app.display_name)
      expect(appnouncements.sdk_integration.content).to have_content(app.uuid)
      expect(appnouncements.sdk_integration.content).to have_content("build.gradle")
    end
    
    scenario "can edit an app/settings" do
      appnouncements.edit_app.load(app_id: app.id)
      expect(appnouncements.edit_app).to be_displayed
      appnouncements.edit_app.edit_app!("New Name", "#FF03FA")
      
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details.flash_messages[0]).to have_content("App was successfully updated.")
      expect(appnouncements.app_details.toolbar.title).to have_content("New Name")
    end
    
    scenario "can destroy an app", js: true do
      appnouncements.edit_app.load(app_id: app.id)
      expect(appnouncements.edit_app).to be_displayed
      
      appnouncements.edit_app.delete_btn.click
      appnouncements.edit_app.confirm_delete_modal.wait_until_confirm_btn_visible
      appnouncements.edit_app.confirm_delete_modal.confirm_input.set app.display_name
      appnouncements.edit_app.confirm_delete_modal.confirm_btn.click
      
      expect(appnouncements.apps).to be_displayed(10)
      expect(appnouncements.apps).to_not have_content(app.display_name)
      expect(appnouncements.apps.flash_messages[0]).to have_content("App was successfully destroyed.")
    end
  end
  
  context "paid user" do
    let (:user) { users(:core_plus) }

    scenario "can create a new app" do
      appnouncements.apps.load

      expect(appnouncements.apps).to be_displayed
      expect(appnouncements.apps).to have_apps
      expect(appnouncements.apps).to_not have_no_apps_card

      expect(appnouncements.apps).to have_toolbar
      expect(appnouncements.apps.toolbar).to have_new_app_btn

      # New App
      appnouncements.apps.toolbar.new_app_btn.click
      expect(appnouncements.new_app).to be_displayed
      appnouncements.new_app.new_app!(:android, "Some Other Name", "#FFFFFF")

      # App Details
      expect(appnouncements.app_details).to be_displayed

      expect(appnouncements.app_details).to have_no_releases_card
      expect(appnouncements.app_details.no_releases_card).to have_new_release_btn

      expect(appnouncements.app_details).to have_toolbar
      expect(appnouncements.app_details.toolbar).to_not have_new_release_btn
      expect(appnouncements.app_details.toolbar.title).to have_content("Some Other Name")

      expect(appnouncements.app_details).to_not have_release_list

      # Flash
      expect(appnouncements.app_details.flash_messages[0]).to have_content("App was successfully created.")
    end
  end
end
