require_relative 'worker'
require 'redis'
require 'net/http'
require 'uri'

redis = Redis.new

worker = Worker.new "google", "http://www.google.fr"

puts redis.lpush "jobListe", worker.toJson



loop do
  puts "Récupération"
  jobStr = redis.lpop "jobListe"

  if !jobStr.nil?
    job = JSON.parse(jobStr)

    response = Net::HTTP.get_response(URI.parse(job['url'])).body

    puts response

  end
  sleep 2
end



