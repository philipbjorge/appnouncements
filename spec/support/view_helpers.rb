module ViewHelpers
  RSpec.shared_context "mocked_user" do
    before do
      without_partial_double_verification {
        allow(view).to receive(:current_user).and_return(user)
      }
    end
  end
end