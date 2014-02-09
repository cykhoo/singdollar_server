require 'sinatra'
require 'singdollar'
require "sinatra/reloader" if development?
require 'newrelic_rpm' if production?
require 'memcachier'
require 'dalli'

set :cache, Dalli::Client.new

get '/' do
  erb :index
end
