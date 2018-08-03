# README

This README would normally document whatever steps are necessary to get the
application up and running.

```
open /Applications/RubyMine.app
```

# Secrets
bin/rails credentials:edit/help

# Proxy Webhooks
`retry -- ssh -R appnouncements:80:appnouncements.localhost:3000 serveo.net`

# Mailer Previews
`http://appnouncements.localhost:3000/rails/mailers`

# Env Vars
```
HEROKU_ENV -- Used to differentiate between prod/staging to allow us to use RAILS_ENV=production as much as possible
SCOUT_NAME -- Used to differentiate between prod/staging in Scout
```

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
