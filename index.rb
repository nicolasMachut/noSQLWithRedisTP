require_relative 'worker'
require_relative 'page_mongo'
require 'redis'
require 'net/http'
require 'uri'
require 'nokogiri'
require 'mongo'
require 'json'
require 'open-uri'


worker = Worker.new "epsi", "http://www.epsi.fr"
worker.save

redis = Redis.new

# mathieu.laporte@gmail.com

jobsTraites = 0

loop do

  puts "#{jobsTraites} job(s) traité(s)"
  nbJobRestant = redis.lrange "jobList", 0, -1
  puts "#{nbJobRestant.length} job(s) restant"

  # Récupération d'un job dans la queue
  jobStr = redis.lpop "jobList"

  if !jobStr.nil?

    # Parse JSON
    job = JSON.parse(jobStr)

    # Get HTML body from the parsed URL
    response = Net::HTTP.get_response(URI.parse(job['url'])).body
    html_doc = Nokogiri::HTML(response)

    # Parse HTML body
    title = html_doc.xpath("//html/head/title").text
    description = html_doc.xpath("//html/head/description").text
    keyWords = html_doc.xpath("//html/head/description").text

    puts title
    puts description
    puts keyWords

    # Save with Mongo
    pageMongo = PageMongo.new
    pageMongo.title = title
    pageMongo.description = description
    pageMongo.url = job['url']
    pageMongo.keywords = keyWords.split(",").to_a
    pageMongo.save


    # Save with ElasticSearch
    page = {title:" ", description: " ", keyWords:[]}
    page[:title] = title
    page[:description] = desription
    page[:keywords] = keyWords
    `curl -XPOST localhost:9200/web/pages/ -d'#{page.to_json}'`



  jobsTraites += 1
  end

  if nbJobRestant = 0
    sleep 5
  end

end