
require "rubygems"
require "sinatra/base"

class MyApp < Sinatra::Base

  get '/' do
    'Hello, nginx and unicorn!'
  end

end




# require 'sinatra'
# require 'grape'

# class API < Grape::API
#   get :hello do
#     { hello: "world" }
#   end
# end

# class Web < Sinatra::Base
#   get '/' do
#     "Hello world."
#   end
# end


# # use Rack::Session::Cookie
# # run Rack::Cascade.new [API, Web]


# change this to:
# run Rack::URLMap.new("/" => Web.new, 
#                      "/api" => API.new)