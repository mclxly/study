require 'grape'

class API < Grape::API
  format :json

  # http://svr1.ruby.test:8080/api/hello
  get :hello do
    { hello: "world" }
  end
end