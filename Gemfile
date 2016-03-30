source 'https://rubygems.org'

gem 'rails', '4.1.13'
gem 'sprockets', '2.11.3'
gem 'httpclient'
gem 'kaminari'
gem 'nokogiri'
gem 'fastimage'
gem 'mysql2'
gem 'rsolr'
gem 'exception_notification'
gem 'newrelic_rpm'
gem 'modernizr-rails'

# QuickSearch theme
gem 'quicksearch_generic_theme', git: 'git@github.com:ncsu-libraries/quick_search-generic_theme.git'

# QuickSearch searchers
#gem 'quicksearch_wikipedia_searcher', git: 'git@github.com:ncsu-libraries/quick_search-wikipedia_searcher.git'
#gem 'quicksearch_open_library_searcher', git: 'git@github.com:ncsu-libraries/quick_search-open_library_searcher.git'
#gem 'quicksearch_arxiv_searcher', git: 'git@github.com:ncsu-libraries/quick_search-arxiv_searcher.git'
#gem 'quicksearch_placeholder_searcher', git: 'git@github.com:ncsu-libraries/quick_search-placeholder_searcher.git'

gem 'quicksearch_wikipedia_searcher', path: 'searcher_repos/quick_search-wikipedia_searcher'
gem 'quicksearch_open_library_searcher', path: 'searcher_repos/quick_search-open_library_searcher'
gem 'quicksearch_arxiv_searcher', path: 'searcher_repos/quicksearch_arxiv_searcher'
gem 'quicksearch_placeholder_searcher', path: 'searcher_repos/quicksearch_placeholder_searcher'

gem 'rack-ssl-enforcer'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', groups: [:development, :test]

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.5'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'rb-fsevent', :require => RUBY_PLATFORM.include?('darwin') && 'rb-fsevent'
  gem 'rb-inotify', :require => RUBY_PLATFORM.include?('linux') && 'rb-inotify'
  gem 'guard'
  gem 'guard-livereload', require: false
  gem 'guard-minitest'
end

group :test do
  gem 'capybara-webkit'
  gem 'launchy'
  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'thin'
  gem 'pry-rails'
  gem 'capistrano', '~> 3.1', require: false
  gem 'capistrano-rails', '~> 1.1.2', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', '~> 0.1.2', require: false
end
