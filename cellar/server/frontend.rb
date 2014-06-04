# app/frontend.rb
require 'sinatra/base'
# This is a rack app.
class Frontend < Sinatra::Base
  get "/"
    haml :index
  end
end

