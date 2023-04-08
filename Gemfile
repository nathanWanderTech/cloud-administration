# frozen_string_literal: true

ruby '2.6.6'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0'

# Statistics tracking
gem 'rack-tracker'

gem 'bootstrap-sass'
gem 'bootstrap_form', '~> 2.7'
gem 'devise' # https://github.com/plataformatec/devise#getting-started
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
gem 'jquery-rails'
gem 'will_paginate'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# gem 'mimemagic', '~> 0.3.7', git: 'https://github.com/mimemagicrb/mimemagic.git', branch: '0.3'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'pg', '~> 0.21'
gem 'rubocop', require: false
gem 'rubocop-faker', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Testing System
  gem 'capybara', '~> 2.13'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rspec-rails', '~> 3.7'
  gem 'selenium-webdriver'
  gem 'sqlite3'
end

group :test do
  gem 'sqlite3'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'annotate'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'better_errors' # Displays better errors
  gem 'binding_of_caller'

  gem 'guard' # Watches for files to change
  gem 'guard-rails', require: false # Rails bindings
  gem 'guard-rspec', require: false # Adds rspec bindings
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
