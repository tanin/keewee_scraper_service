require 'bundler/setup'
Bundler.require(:default)

require File.expand_path '../server.rb', __FILE__

map '/' do
  run Sinatra::Application.run!
end
