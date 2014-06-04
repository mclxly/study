require_relative "./frontend.rb"
require_relative "./api.rb"
require_relative "./twitter_api.rb" # add this

# test url:
# http://svr1.ruby.test:8080/twitter/statuses/public_timeline
# http://svr1.ruby.test:8080/api/hello
# http://svr1.ruby.test:8080/
run Rack::URLMap.new("/" => Frontend, 
                     "/api" => API,
                     "/twitter" => Twitter::API)