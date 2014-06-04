=begin
# config.ru
require_relative "./frontend.rb"
require_relative "./api.rb"

# Here base URL's are mapped to rack apps.
run Rack::URLMap.new("/" => Frontend.new, 
                     "/api" => Api.new) 
=end



# Example config.ru

require 'sinatra'
require 'grape'

class API < Grape::API
  
  format :json

  get :hello do
    {hello: "world"}
  end
end

class Web < Sinatra::Base
  get '/' do
    "Hello world."
  end
end

use Rack::Session::Cookie
run Rack::Cascade.new [API, Web]                     