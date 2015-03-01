require 'json'
require 'redis'
class Worker

  def initialize (name, url)
    @name = name
    @url = url;
    @h = {}
    @h['name'] = @name
    @h['url'] = @url
    @redis = Redis.new
  end

  def name
    @name
  end
  def url
    @url
  end

  def toJson ()
    @h.to_json
  end

  def save ()
    @redis.lpush "jobList", toJson
  end

end