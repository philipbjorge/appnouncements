require 'rails_helper'

RSpec.feature "ReleaseNotesApi", type: :feature do
  fixtures :subscriptions, :plans, :apps, :releases
  let (:app) { apps(:core_plus_app_with_releases) }
  
  context "core plan" do
    it "should show a range of release notes" do
      visit "/api/v1/release_notes/#{app.uuid}/#{app.releases[1].version}...#{app.releases[0].version}"

      expect(page).to have_selector(".release", count: app.releases.length)
      app.releases.each {|r| expect(page).to have_content(r.body) }
    end
    
    it "should show a single note" do
      visit "/api/v1/release_notes/#{app.uuid}/#{app.releases.first.version}...#{app.releases.first.version}"
      
      expect(page).to have_selector(".release", count: 1)
      expect(page).to have_content(app.releases.first.body)
    end
  end
  
  context "free plan" do
    let (:app) { apps(:free_app_1) }
    
    it "should show branding" do
      visit "/api/v1/release_notes/#{app.uuid}/..."
      expect(page).to have_content("Powered by Appnouncements")
    end
  end
end
