require 'rails_helper'

RSpec.feature "Apps", type: :feature do
  fixtures :users
  let (:confirmed_user) { users(:confirmed) }
  let(:app) { PrismApp.new }
  
  context "when logged in" do
    before do
      login_as(confirmed_user, :scope => :user)
    end
    
    scenario "first time experience" do
      app.apps.load
      
      # OOBE/No Cards View
      expect(app.apps).to be_displayed
      
      expect(app.apps).to have_no_apps_card
      expect(app.apps.no_apps_card).to have_new_app_btn
      
      expect(app.apps).to have_toolbar
      expect(app.apps.toolbar).to_not have_new_app_btn
      
      # New App
      app.apps.no_apps_card.new_app_btn.click
      expect(app.new_app).to be_displayed
      app.new_app.new_app!(:android, "Some Name", "#FFFFFF")
      
      # App Details
      expect(app.app_details).to be_displayed
      
      expect(app.app_details).to have_no_releases_card
      expect(app.app_details.no_releases_card).to have_new_release_btn
      
      expect(app.app_details).to have_toolbar
      expect(app.app_details.toolbar).to_not have_new_release_btn
      
      # TODO: Flash section?
      expect(page).to have_content("App was successfully created.")
    end
  end
end
