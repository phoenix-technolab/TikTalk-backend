require 'connection_pool'

# My Redis
module MyRedis
  REDIS = ConnectionPool.new(size: 20) do
    Redis.new
  end

  def client
    MyClient.new
  end

  class MyClient
    def get(key)
      REDIS.with do |conn|
        conn.get(key)
      end
    end

    def set(key, val, options = {})
      REDIS.with do |conn|
        conn.set(key, val, options)
      end
    end

    def del(key)
      REDIS.with do |conn|
        conn.del(key)
      end
    end

    def expire(key, seconds)
      REDIS.with do |conn|
        conn.expire(key, seconds)
      end
    end
  end

  module_function :client
end