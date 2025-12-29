source "https://rubygems.org"
ruby "3.3.5"

gem "rails", "~> 8.0.4"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "dartsass-rails"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Infrastructure
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "redis"
gem "sidekiq"

# Auth & Forms
gem "devise"
gem "simple_form"

# AI & API (Moved out of :test so Render can see them)
gem "ruby-openai"
gem "gemini-ai"
gem "httparty"
gem "rspotify"
gem "dotenv-rails"

# UI & Analytics (Moved out of :test)
gem "tailwindcss-rails", "~> 4.4"
gem "turbo-rails"
gem "chartkick"
gem "groupdate"
gem "kaminari"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

gem 'dotenv-rails', groups: [:development, :test]
group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
