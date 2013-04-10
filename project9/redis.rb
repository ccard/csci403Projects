#! /usr/bin/env ruby

#Chris Card
#Project 9

require "redis"
require "json"

@redis = Redis.new :host => "pub-redis-13059.us-west-1.1.azure.garantiadata.com", :port => 13059, :password => "wuwnosql403"

#Finds the value of a key
def find
	begin
		puts "Find by key:"
		puts "Enter key:"
		key = gets.chomp
		puts "#{@redis.get key}"

	rescue Redis::CommandError => e
		puts "Value for key can not be obtained by gets"
	end

end

#adds a key and a value
def add
	puts "Add an element"
	puts "Enter key:"
	key = gets.chomp
	puts "Enter value:"
	value = gets.chomp
	@redis.set key, value
end

#increments the value of a key
def incer
	puts "Increase count"
	puts "Enter key of count:"
	key = gets.chomp
	begin
		@redis.incr key
		puts "count is now => #{@redis.get key}"
	rescue Redis::CommandError => e
		puts "No such key or invalid type of key's value"
	end
end

#allows user to add multiple keys and values
def addm
	x = Hash.new
	puts "Enter many keys and values(type !end into key to terminate input"
	puts "Enter key:"
	key = gets.chomp
	puts "Enter value"
	value = gets.chomp
	puts ""
	x[key] = value
	while true
		puts "Enter key:"
		key = gets.chomp
		key != "!end" ? "" : break
		puts "Enter value"
		value = gets.chomp
		puts ""
		x.key?(key) ? "#{puts "The key already exists please try again"}" : "#{x[key] = value}"
	end

	@redis.multi do
		x.each do | key,value |
			@redis.set key,value
		end
	end
end

#allows user to append to the value of a key
def append
	puts "Append a value to a key"
	puts "Enter key:"
	key = gets.chomp
	puts "Enter value to append:"
	value = gets.chomp

	puts "#{@redis.append key,value}"
end

#allows user to store a list 
def storeList
	puts "Store a list of values"
	puts "Enter key for list (existing|new):"
	key = gets.chomp

	while true
		puts "Enter value or '!end' to stop input:"
		value = gets.chomp
		value == "!end" ? break : ""
		@redis.lpush key, value
	end
end

#gets the list stored in a key and prints the elements out
def getList
	puts "Get a list"
	puts "Enter key of list:"
	key = gets.chomp
	begin
		length = @redis.llen key
		list = @redis.lrange key, 0, length
		list.empty? ? "#{puts "there is no such list"}" : 
				list.each do |element| 
					puts "#{element}" 
				end
	rescue Redis::CommandError => e
		puts "The key entered doesn't map to a list"
	end
end

#allows user to get specific element of a list
def getElement
	puts "Get an element of a list"
	puts "Enter key of list:"
	key = gets.chomp
	begin
		length = @redis.llen key
		puts "Enter the index you want between 0 and #{length-1}"
		index = gets.chomp
		puts "Element at #{index} is: #{@redis.lindex key,index}"
	rescue Redis::CommandError => e
		puts "Either you put in the incorrect index or the key doesn't map to a list"
	end
end

#allows user to create a set
def createSet
	puts "Create or add to a set"
	puts "Enter key for set:"
	key = gets.chomp
	begin
		@redis.smembers key

		while true
			puts "Enter value or '!end' to terminate input"
			value = gets.chomp
			value == "!end" ? break : ""
			@redis.sadd key,value
		end

	rescue Redis::CommandError => e
		puts "Invalid set or key already exists and is not a set"
	end
end

#finds the inter section between two sets
def findIntersecion
	puts "Find the intersection of 2 sets"
	puts "Enter key of set 1:"
	key1 = gets.chomp
	puts "Enter key of set 2:"
	key2 = gets.chomp

	begin
		puts "#{@redis.sinter key1,key2}"
	rescue Redis::CommandError => e
		puts "One of the sets may not exist"
	end
end

#gets the whole set stored in a key
def getSet
	puts "Get a set"
	puts "Enter set key:"
	key = gets.chomp

	begin
		members = @redis.smembers key
		members.each do |member|
			puts "#{member}"
		end
	rescue Redis::CommandError => e
		puts "Set doesn't exist or key doesn't map to a set"
	end
end

#allows users to find keys based on a pattern
def getKey
	puts "Get all keys matching a pattern"
	puts "Uses: ? mathes any character only once"
	puts "      * 0->any number of characters"
	puts "      [] mathes characters provided and nothing else"
	puts "Enter pattern:"
	pattern = gets.chomp

	begin
		puts "The matching keys are:"
		keys = @redis.keys pattern
		keys.empty? ? "#{puts "no keys matching pattern found"}":
				keys.each do |key|
					puts "#{key}"
				end
	rescue Redis::CommandError => e
		puts "Invalid pattern"
	end
end

#allows users to renaim the keys
def rename
	puts "Rename a key"
	puts "Enter original key:"
	orginkey = gets.chomp
	puts "Enter new key:"
	newkey = gets.chomp

	begin
		result = @redis.renamenx orginkey,newkey
		result ? "#{puts "rename success"}" : "#{puts "rename fail"}"
	rescue Redis::CommandError => e
		puts "Invalid rename command"
	end
end

#returns the time on the server
def time
	puts "Get server time"
	puts "Server time is #{@redis.time}"
end

#gets the type of the value stored at a key
def valType
	puts "Get type of value stored at key"
	puts "Enter key:"
	key = gets.chomp
	puts "Type is: #{@redis.type key}"
end

#decrements the value stored at a key
def decr
	puts "Decrease count"
	puts "Enter key of count:"
	key = gets.chomp
	begin
		@redis.decr key
		puts "count is now => #{@redis.get key}"
	rescue Redis::CommandError => e
		puts "No such key or invalid type of key's value"
	end
end

def verify
	puts "Verify that a set contains an element"
	puts "Enter key of set:"
	key = gets.chomp
	puts "Enter value to verify:"
	value = gets.chomp

	begin
		has = @redis.sismember key,value 
		has ? "#{puts "#{value} :is a member of the set"}" :
		           "#{puts "The set has no memeber: #{value}"}"
	rescue Redis::CommandError => e
		puts "The key doesn't map to a set"
	end
end

def main_menu
  puts "\nMain Menu."
  puts "A. Find obj"
  puts "B. Add obj"
  puts "C. Increment count"
  puts "D. Add multiple objects"
  puts "E. Append to value to key"
  puts "F. Store a list of values"
  puts "G. Get a list"
  puts "H. Get element of list"
  puts "I. Create or add to a set"
  puts "J. Find intersection of two sets"
  puts "K. Get a set"
  puts "L. Get a keys matching a pattern"
  puts "M. Rename a key"
  puts "N. Get server time"
  puts "O. Get the type of a keys value"
  puts "P. Decrement counter"
  puts "R. Verify an element of a set"
  puts "Q. Quit"
end

def execute_command(command)
  case command
  when "A"
    find
  when "B"
    add
  when "C"
    incer
  when "D"
  	addm
  when "E"
    append
  when "F"
    storeList
  when "G"
  	getList
  when "H"
  	getElement
  when "I"
  	createSet
  when "J"
  	findIntersecion
  when "K"
  	getSet
  when "L"
  	getKey
  when "M"
  	rename
  when "N"
  	time
  when "O"
  	valType
  when "P"
  	decr
  when "R"
  	verify
  when "Q"
    puts "Quitting... buh-bye."
  else
    puts "Sorry, I don't know how to do that. Too bad so sad."
  end
end

command = nil
puts "Snack Attack. Whee!"
while (command != 'Q')
  main_menu
  execute_command(command = gets.chomp!)
end