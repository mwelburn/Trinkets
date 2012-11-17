source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'devise', '~> 2.1'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'jquery-rails'

#gem 'cancan'
#gem 'paperclip'
#gem "paperclip-aws", "~> 1.6.6"
#gem 'aws-s3', :require => 'aws/s3'
#gem 'aws-sdk', '~> 1.3.4'

group :assets do
  gem 'sass-rails',   '~> 3.2'
  #gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.2.1.0'
end

group :development do
  gem 'sqlite3'
  gem 'debugger'
  gem 'rspec-rails'
  gem 'faker'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
  
  gem 'rspec'
  gem 'webrat'
  gem 'factory_girl_rails', '~> 4.0'
end

group :production do
  gem 'heroku'
  gem 'pg'
  gem 'thin'
end