#! usr/bin/env ruby
#Chris Card

require 'mongo'
require 'json'

#MONGO_URL="mongodb://junk:wuwnosql403@staff.mongohq.com:10033/zoolicious"
#db = URI.parse(MONGO_URL)
#db_name = db.path.gsub('/^\//','')
#@connect = Mongo::Connection.new(db.host,db.port).db(db_name)
#@connect.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)

@db = Mongo::MongoClient.new('staff.mongohq.com',10033).db("zoolicious")



def listAll

	zoos = db.zoo.find
	zoos.forEach(printjson)
end