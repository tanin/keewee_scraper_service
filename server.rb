require 'sinatra'
require 'sinatra/json'
require 'sinatra/strong-params'
require 'mongoid'
require 'delayed_job_mongoid'
require File.expand_path 'serializers/stories/post_story_serializer.rb'
require File.expand_path 'serializers/stories/stories_serializer.rb'

# DB Setup
Mongoid.load! 'config/mongoid.config'
set :show_exceptions, false

before do
  content_type 'application/json'
end

error RequiredParamMissing do
  [400, env['sinatra.error'].message]
end

error Mongoid::Errors::DocumentNotFound do
  status 404
end

post '/stories', needs: [:url] do
  @story = Story.create(url: params[:url])
  status @story.errors.blank? ? 201 : 422
  json PostStorySerializer.new(@story).as_json
end

get '/stories/:id' do |id|
  @story = Story.find(id)

  if @story.scrape_status.blank?
    @story.update(scrape_status: 'Pending')
    @story.delay.scrape!
  end

  json StoriesSerializer.new(@story).as_json
end
