#! /usr/bin/env ruby
#Chris Card

require 'mongo'
require "uri"
require 'json'


@db = Mongo::Connection.new("staff.mongohq.com",10033).db("zoolicious")
@db.authenticate "ccard","wuwnosql403"



def listAll

	zoos = @db.collection 'zoos'
	allZoos = zoos.find
	puts "Zoos:"
	allZoos.each do |zoo|
		puts "Zoo #{zoo['name']}"
	end

	puts "Habitats:"
	habitats = @db.collection 'habitats'
	allhabitats = habitats.find({}, :fields => ["name","description"])
	allhabitats.each do |habitat|
		puts "\nName: #{habitat['name']}\nDescription: #{habitat['description']}"
	end

	puts "Animals:"
end

listAll
