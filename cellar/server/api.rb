# This is also a rack app.
class API < Sinatra::Base

  get "/" do  # when this is mapped below, it will mean it gets called via "/api/"
    "This is the API"
  end
end