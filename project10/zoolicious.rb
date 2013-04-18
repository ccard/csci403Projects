#! usr/bin/env ruby
#Chris Card

require 'mongo'
require "uri"
require 'json'


@db = Mongo::Connection.new("staff.mongohq.com",10033).db("zoolicious")
@db.authenticate "ccard","wuwnosql403"



def listAll

	zoos = @db.collection 'zoos'
	allZoos = zoos.find()
	allZoos.each do |zoo|
		puts "#{zoo.to_json}"
	end
end

listAll