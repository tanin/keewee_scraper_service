require 'sinatra'
require 'sinatra/json'
require 'sinatra/strong-params'
require 'mongoid'
require File.expand_path 'serializers/stories/post_story_serializer.rb'

# DB Setup
Mongoid.load! 'config/mongoid.config'
set :show_exceptions, false

before do
  content_type 'application/json'
end

error RequiredParamMissing do
  [400, env['sinatra.error'].message]
end

post '/stories', needs: [:url] do
  @story = Story.create(url: params[:url])
  status @story.errors.blank? ? 201 : 422
  json PostStorySerializer.new(@story).as_json
end
