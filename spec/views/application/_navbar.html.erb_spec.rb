require 'rails_helper'

RSpec.describe "application/_navbar", type: :view do
  before do
    without_partial_double_verification {
      allow(controller).to receive(:current_user).and_return(nil)
    }
  end

  context "when not logged in" do
    before do
      @user = nil
    end

    it "displays sign up" do
      render
      expect(rendered).to match /Sign Up/
    end
  end

  context "when not logged in" do
    before do
      @user = true
    end

    it "displays sign up" do
      render
      expect(rendered).to_not match /Sign Up/
    end
  end
end
