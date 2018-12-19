source 'https://rubygems.org'

gem 'rails', '~> 5.0.1'
gem 'sass-rails', '~> 5.0'
gem "rails-i18n"

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-easing-rails'

gem 'devise'
gem 'devise-i18n'
gem 'kaminari'

gem 'omniauth-facebook'

# https://chartkick.com/
# https://github.com/ankane/chartkick
# https://trendapi.org/playground
gem "chartkick"
# https://github.com/ankane/blazer/

# http://tech.guojheng-lin.com/posts/2015/12/03/write-a-ruby-file-regularly-to-catch-crawling-web-page-data/

# https://github.com/tyrauber/stock_quote
gem "watir"

# Use Puma as the app server
gem 'puma', '~> 3.0'
gem "mysql2"

gem 'bootstrap-sass', '~> 3.3.6'
gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

gem 'faker'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  gem 'activerecord-import'
  
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
