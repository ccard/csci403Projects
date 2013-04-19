#! /usr/bin/env ruby
#Chris Card

require 'mongo'
require "uri"
require 'json'


@db = Mongo::Connection.new("staff.mongohq.com",10033).db("zoolicious")
@db.authenticate "ccard","wuwnosql403"


#lists all animals habitats and zoos
def listAll
	#prints out every zoo's name
	zoos = @db.collection 'zoos'
	allZoos = zoos.find({}, :fields => ["name"])
	puts "Zoos:"
	allZoos.each do |zoo|
		puts "Zoo #{zoo['name']}"
	end

	#prints out every habitat's name and description
	puts "\nHabitats:"
	habitats = @db.collection 'habitats'
	allhabitats = habitats.find({}, :fields => ["name","description"])

	allhabitats.each do |habitat|
		puts "\nName: #{habitat['name']}\nDescription: #{habitat['description']}"
	end

	#prints out every animal's name, description and cuteness as well as any associted
	#habitats
	puts "\nAnimals:"
	animals = @db.collection 'animals'
	allanimals = animals.find({}, :fields => ["name","description","cuteness","habitat_id"])

	allanimals.each do |animal|
		puts "\nName: #{animal['name']}\nDiscription: #{animal['description']}\nCuteness: #{animal['cuteness']}"

		#gets all the habitats the have the id in animals habitat_id
		#then prints out their name
		allhabitats = habitats.find({"_id" => animal['habitat_id']}, :fields => ['name'])
		puts "Habitats:"
		allhabitats.each do |habitat|
			puts "#{habitat['name']}"
		end
	end
end

#prompts user to add animals
def addAnimal
	puts "\nAdd new animal:"

	puts "Name:"
	name = gets.chomp
	
	puts "\nDescription:"
	descript = gets.chomp

	#gets cuteness form user and checks to see that
	#its an int if not reprompts tha user
	puts "\nCuteness(int)"
	cuteness = gets.chomp
	while not cuteness.is_integer?
		puts "\nNot an integer try again:"
		cuteness = gets.chomp
	end

	#gets the animals collection and then inserts the new animal
	animals = @db.collection 'animals'
	animals.insert({"name" => "#{name}","description" => "#{descript}", "cuteness" => cuteness})
end

#This string class adds the function is_integer
class String
	def is_integer?
		#converts to an int and back to string and if it isn't the
		#same string then it is not an int
		self.to_i.to_s == self
	end
end

#-----------------------------------------------------------------------------------------
# Main
#-----------------------------------------------------------------------------------------

comand = 'V'

while not comand.eql? 'Q'
	puts "\nMain menu:"
	puts "A. To list all zoos, habitats and animals."
	puts "B. To add an animal to the db."
	puts "Q. Quit."
	comand = gets.chomp
	case comand
		when 'A'
			listAll
		when 'B'
			addAnimal
		when 'Q'
			puts "Thanks for playing!"
			break
		else
			puts "I haven't heard of that option before try again"
	end
end