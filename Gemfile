source "https://rubygems.org"

gem "ruby_llm"
gem "dotenv-rails", groups: %i[development test]
gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "devise"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "solid_cable", group: :development
gem "solid_queue", group: :development
gem "solid_cache", group: :development
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 2.0"
gem "sprockets-rails"
gem "bootstrap", "~> 5.3"
gem "autoprefixer-rails"
gem "font-awesome-sass", "~> 6.1"
gem "simple_form", github: "heartcombo/simple_form"
gem "sassc-rails"
gem "redcarpet"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "rubocop-rails-omakase", require: false
  gem "ruby-lsp", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

gem "rspec", "~> 3.13", group: :test

group :development, :test do # rubocop:disable Bundler/DuplicatedGroup
  gem "rspec-rails", "~> 8.0"
end
