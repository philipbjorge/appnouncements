require 'rails_helper'

RSpec.describe "application/_navbar", type: :view do
  include_context "mocked_user"

  context "when not logged in" do
    let(:user) { nil }

    it "displays sign up" do
      render
      expect(rendered).to match /Sign Up/
    end

    it "displays sign in" do
      render
      expect(rendered).to match /Sign In/
    end
  end

  context "when logged in" do
    let(:user) { "some user" }

    it "displays sign out" do
      render
      expect(rendered).to match /Sign Out/
    end
  end
end
