require 'rails_helper'

RSpec.feature "Releases", type: :feature do
  fixtures :users, :subscriptions, :plans, :apps, :releases
  let(:appnouncements) { PrismApp.new }

  before do
    login_as(user, :scope => :user)
  end

  context "app with releases" do
    let (:user) { users(:core_plus) }
    let (:app) { user.apps.to_a.find {|a| a.releases.length > 0} }
    
    scenario "can create a new release" do
      appnouncements.app_details.load(app_id: app.id)
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details).to have_release_list(count: user.apps.length)
      
      # New Release
      appnouncements.app_details.toolbar.new_release_btn.click
      appnouncements.new_android_release.new_release!("Some Title", 123, "1.3.3.7", "Some Body", true)

      expect(appnouncements.app_details).to be_displayed
      release = Release.without_default_order.last
      expect(appnouncements.app_details).to have_release_list(count: 3)
      expect(appnouncements.app_details.release_list[0].title).to have_content(release.title)
      expect(appnouncements.app_details.release_list[0].version).to have_content(release.version)
      expect(appnouncements.app_details.release_list[0].version).to have_content(release.display_version)
      expect(appnouncements.app_details.release_list[0].body).to have_content(release.body)

      expect(appnouncements.app_details.flash_messages[0]).to have_content("Release was successfully created")
    end
    
    scenario "can list releases" do
      appnouncements.app_details.load(app_id: app.id)
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details).to have_release_list(count: user.apps.length)
    end
    
    scenario "can update a release" do
      appnouncements.app_details.load(app_id: app.id)
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details).to have_release_list(count: user.apps.length)

      appnouncements.app_details.release_list[0].edit_btn.click
      appnouncements.edit_android_release.edit_release!("A NEW TITLE", 999, "1.29", "A NEW BODY", true)

      app.releases.reload
      release = app.releases.first
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details).to have_release_list(count: user.apps.length)
      expect(appnouncements.app_details.release_list[0].title).to have_content(release.title)
      expect(appnouncements.app_details.release_list[0].version).to have_content(release.version)
      expect(appnouncements.app_details.release_list[0].version).to have_content(release.display_version)
      expect(appnouncements.app_details.release_list[0].body).to have_content(release.body)

      expect(appnouncements.app_details.flash_messages[0]).to have_content("Release was successfully updated")
    end
    
    scenario "can destroy a release", js: true do
      appnouncements.app_details.load(app_id: app.id)
      expect(appnouncements.app_details).to be_displayed
      expect(appnouncements.app_details).to have_release_list(count: user.apps.length)
      
      appnouncements.app_details.release_list[0].delete_btn.click
      appnouncements.app_details.confirm_delete_modal.wait_until_confirm_btn_visible
      appnouncements.app_details.confirm_delete_modal.confirm_btn.click

      expect(appnouncements.app_details).to have_release_list(count: user.apps.length - 1)
      expect(appnouncements.app_details.flash_messages[0]).to have_content("Release was successfully destroyed.")
    end
  end
end
