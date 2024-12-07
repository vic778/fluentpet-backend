# config/initializers/redis.rb

# Require the redis gem
require "redis"

# Initialize Redis connection
$redis = Redis.new(url: ENV["REDIS_URL"])
# $redis = Redis.new(host: ENV["REDIS_URL"], port: ENV["REDIS_PORT"])
