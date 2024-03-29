require 'rails_helper'

RSpec.describe Api::V1::ReleaseNotesController, type: :controller do

  describe "GET #view" do
    it "returns http success" do
      get :view
      expect(response).to have_http_status(:success)
    end
  end

end
