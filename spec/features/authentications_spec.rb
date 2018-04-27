require 'rails_helper'

RSpec.feature "Authentications", type: :feature do
  fixtures :users
  let (:user) { users(:alice) }

  scenario "logging in" do
    set_omniauth(uid: user.auth0_id)

    visit root_path

    # should not create a new user
    expect {
      click_link "Login"
    }.to_not change(User, :count)

    # should redirect to apps page
    expect(page.current_url).to eq(apps_url)
  end

  scenario "registering" do
    set_omniauth(uid: "uid that does not exist!")

    visit root_path

    # should create a new user
    expect {
      click_link "Login"
    }.to change(User, :count).by(1)

    # should redirect to apps page
    expect(page.current_url).to eq(apps_url)
  end

  xscenario "omniauth failure" do
    set_invalid_omniauth()

    visit root_path

    # should not create a new user
    expect {
      click_link "Login"
    }.to_not change(User, :count)
  end
end
