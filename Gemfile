source 'https://rubygems.org'
ruby '2.1.0'

gem 'rails', '4.0.0'
gem 'jquery-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'sqlite3'
gem 'figaro'
gem 'draper'
gem 'lazy_high_charts'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'terminal-notifier-guard'
  gem 'launchy'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '>= 1.2.0'
  gem 'spork-rails', github: 'sporkrb/spork-rails'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'rb-fsevent'
end

group :production do
  # Using fork until Pull Request #15 or #17 are merged fixing the SPI calls
  # to use Platform.driver
  gem 'pi_piper', github: 'bguest/pi_piper',
                  branch: 'stub-driver'
end
