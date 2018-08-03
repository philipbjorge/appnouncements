puts ENV["HEROKU_ENV"]
puts ENV["RAILS_ENV"]
puts Rails.env
puts (ENV["HEROKU_ENV"] || ENV["RAILS_ENV"]).to_sym
puts Rails.application.credentials
ChargeBee.configure(Rails.application.credentials[(ENV["HEROKU_ENV"] || ENV["RAILS_ENV"]).to_sym][:chargebee])