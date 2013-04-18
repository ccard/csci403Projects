#! usr/bin/env ruby
#Chris Card

require 'mongo'
require "uri"
require 'json'


@db = Mongo::MongoClient.new("staff.mongohq.com",10033).db("zoolicious")
@db.authenticate "ccard","wuwnosql403"



def listAll

	zoos = connect.zoo.find
	zoos.forEach(printjson)
end