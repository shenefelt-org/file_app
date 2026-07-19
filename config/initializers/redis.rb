## INIT redis global

$redis = Redis.new(host: ENV.fetch("REDIS_HOST"),port: ENV.fetch("REDIS_PORT") "redis://localhost:6379/1")
