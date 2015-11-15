source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.0'

gem 'jquery-rails'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'

gem 'uglifier', '>= 1.3.0'

gem 'devise'
gem 'simple_form'

gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-rails'

gem 'time_diff'
gem 'mongoid', '~> 5.0.0'
gem 'enumerize'
gem 'cocoon', github: 'thiago-sydow/cocoon'
gem 'twitter-bootstrap-rails-confirm'
gem 'jquery-datatables-rails', '~> 3.2.0'
gem 'kaminari'

gem 'burgundy'
gem 'rollbar', '~> 1.5.3'

gem 'passenger'

gem 'newrelic_rpm'

gem 'prawn'
gem 'prawn-table'

gem 'mail_form'

gem 'axlsx'
gem 'rubyzip'
gem 'roo'
gem 'lograge'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'rack-mini-profiler'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'mailcatcher'
  gem 'pry'
  gem 'pry-byebug'
  gem 'zeus'
  gem 'database_cleaner', git: 'https://github.com/DatabaseCleaner/database_cleaner.git'
  gem 'factory_girl_rails'
end

group :test do
  gem 'shoulda-matchers'
  gem 'mongoid-rspec', '3.0.0'
  gem 'simplecov', require: false
  gem 'coveralls', require: false
  gem 'turnip'
  gem 'rspec_candy', '~> 0.3.1'
  gem 'fuubar'
  gem 'faker'
end
