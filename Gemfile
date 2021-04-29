source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# https://diver.diveintocode.jp/curriculums/464
# ruby '2.6.5'

#Core
gem 'rails', '~> 5.2.5'
gem 'bootsnap', '>= 1.1.0', require: false

#MiddleWare
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

#Frontend
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'
gem 'rinku'
gem 'ransack'
gem 'acts-as-taggable-on', '~> 7.0'

#Backend
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use ActiveStorage variant
gem 'carrierwave'
gem 'mini_magick', '~> 4.8'
gem 'mimemagic', '0.3.7'

# Authentication
gem 'devise'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'pry-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  # gem 'letter_opener_web'
  gem 'rspec-rails', '~> 3.8'
  gem 'factory_bot_rails'
  gem 'spring-commands-rspec'
  gem 'launchy'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #  gem 'letter_opener_web'
  gem 'bullet'
end

# Mailer
gem 'letter_opener_web'

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'fog-aws'
gem 'dotenv-rails'
gem 'unicorn' # アプリケーションサーバのunicorn
gem 'mini_racer', platforms: :ruby # デプロイ時に必要
group :development, :test do
  gem 'capistrano', '3.6.0' # capistranoのツール一式
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
  gem 'faker'
end

