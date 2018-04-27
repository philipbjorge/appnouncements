Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    'wExiyTFMn0OHoRIItuPXxU1CuGCpXVsf',
    ENV['AUTH0_CLIENT_SECRET'],
    'appnouncements.auth0.com',
    callback_path: "/auth/oauth2/callback",
    authorize_params: {
      scope: 'openid profile',
      audience: 'https://appnouncements.auth0.com/userinfo'
    }
  )
end
