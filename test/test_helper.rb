ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'vcr'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  extend VcrTest
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  Capybara.run_server = true 
  Capybara.server_port = 7000
  Capybara.app_host = "http://localhost:#{Capybara.server_port}" 
  Capybara.javascript_driver = :webkit
  Capybara.default_wait_time = 8
end

VCR.configure do |c|
  # c.ignore_localhost = true
  c.hook_into :webmock
  c.cassette_library_dir = 'test/vcr_cassettes'
  c.filter_sensitive_data('<AUTHORIZATION_CLIENT_KEY>') do |interaction|
    QuickSearch::Engine::APP_CONFIG['summon']['client_key']
  end
  c.filter_sensitive_data('<AUTHORIZATION_SECRET_KEY>') do |interaction|
    QuickSearch::Engine::APP_CONFIG['summon']['secret_key']
  end
end
