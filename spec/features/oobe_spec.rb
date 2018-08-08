require 'rails_helper'

RSpec.feature "OOBE", type: :feature do
  fixtures :users, :subscriptions, :plans, :apps
  let(:app) { PrismApp.new }

  before do
    login_as(user, :scope => :user)
  end

  context "new free user" do
    let (:user) { users(:new_free) }
    scenario "first time experience - create app, create release" do
      app.apps.load

      # OOBE/No Cards View
      expect(app.apps).to be_displayed

      expect(app.apps).to_not have_apps
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

      expect(app.app_details).to_not have_release_list

      # Flash
      expect(app.app_details.flash_messages[0]).to have_content("App was successfully created.")

      # New Release
      app.app_details.no_releases_card.new_release_btn.click
      app.new_android_release.new_release!("Some Title", 123, "1.3.3.7", "Some Body", true)

      expect(app.app_details).to be_displayed
      expect(app.app_details).to_not have_no_releases_card
      expect(app.app_details).to have_toolbar
      expect(app.app_details.toolbar).to have_new_release_btn

      release = Release.without_default_order.last
      expect(app.app_details).to have_release_list(count: 1)
      expect(app.app_details.release_list[0].title).to have_content(release.title)
      expect(app.app_details.release_list[0].version).to have_content(release.version)
      expect(app.app_details.release_list[0].version).to have_content(release.display_version)
      expect(app.app_details.release_list[0].body).to have_content(release.body)

      expect(app.app_details.flash_messages[0]).to have_content("You just created your first release")
    end
  end
end
