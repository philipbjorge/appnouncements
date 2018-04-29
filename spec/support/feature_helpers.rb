module FeatureHelper
  def set_omniauth(opts = {})
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:auth0] = opts
  end

  def set_invalid_omniauth(opts = {})
    set_omniauth(:invalid_crendentials)
  end
end