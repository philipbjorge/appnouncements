source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem "slim-rails"

gem 'dotenv-rails', groups: [:development, :test]

gem 'devise'
gem 'any_login'

gem 'stripe_event'
gem 'stripe'

gem 'simple_form'
gem 'active_link_to'
gem 'pundit'
gem 'shoulda-matchers'
gem 'pundit-matchers'
gem 'redcarpet'
gem 'onebox'
gem 'html-pipeline'

gem 'twitter_cldr'
gem 'octicons_helper'

# https://github.com/basecamp/local_time
# https://github.com/schneems/maildown
# premailer for inlining css?

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :production do
  gem "lograge"
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem "rspec-rails"
  gem "guard"
  gem "guard-rspec"
  gem 'pry-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "better_errors"
  gem "binding_of_caller"
  gem "awesome_print"
  gem "letter_opener"
  gem "bullet"
  gem 'rack-mini-profiler'
  gem 'flamegraph'
  gem 'stackprof'
  gem 'annotate'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
