require 'mongo'
require 'mongoid'

c = Mongo::Connection.new
Mongoid.database = c['web']

class PageMongo

  include Mongoid::Document

  field :title, type: String, default: 'empty'
  field :url, type: String, default: 'empty'
  field :keywords, type: Array, defautl: 'empty'
  field :description, type: String, dafault: 'empty'

end