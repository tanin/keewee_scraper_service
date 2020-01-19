require 'rack/test'
require 'rspec'
require 'database_cleaner'
require 'byebug'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../server.rb', __FILE__
require File.expand_path '../../models/url.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure do |config|
  config.include RSpecMixin

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
