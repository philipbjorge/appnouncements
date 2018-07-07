chargebee_env = ENV["CHARGEBEE_TEST_ENV"].present? ? :development : Rails.env.to_sym
ChargeBee.configure(Rails.application.credentials[chargebee_env][:chargebee])