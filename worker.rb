require 'json'
class Worker

  def initialize (name, url)
    @name = name
    @url = url;
    @h = {}
    @h['name'] = @name
    @h['url'] = @url
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

end