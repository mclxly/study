require "redis"

redis = Redis.new(:host => "192.168.1.103", :port => 6379)
redis.set("mykey", "hello world")
print redis.get("mykey")