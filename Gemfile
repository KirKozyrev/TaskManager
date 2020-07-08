source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'active_model_serializers'
gem 'bcrypt', '~> 3.1.7'
gem 'file_validators'
gem 'jbuilder', '~> 2.7'
gem 'js-routes'
gem 'kaminari'
gem 'mini_magick'
gem 'newrelic_rpm'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'responders'
gem 'rollbar'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sidekiq-throttled'
gem 'sidekiq-unique-jobs', '~> 6.0.13'
gem 'simple_form'
gem 'slim-rails'
gem 'state_machines'
gem 'state_machines-activerecord'
gem 'virtus'
gem 'webpacker', '~> 4.0'
gem 'webpacker-react'

gem "aws-sdk-s3", require: false
gem 'bootsnap', '>= 1.4.2', require: false
gem 'coveralls', '>= 0.8.23',require: false

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'rubocop'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.16.1',require: false
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
