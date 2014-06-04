# app/frontend.rb
require "rubygems"
require 'sinatra/base'
# This is a rack app.
class Frontend < Sinatra::Base

  get "/" do
    'hello Sinatra + Grape'
  end

end
