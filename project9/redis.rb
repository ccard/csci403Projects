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

#Adds a key and a value
def add
	puts "Add an element"
	puts "Enter key:"
	key = gets.chomp

	puts "Enter value:"
	value = gets.chomp

	@redis.set key, value
end

#Increments the value of a key
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

#Allows user to add multiple keys and values
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

#Allows user to append to the value of a key
def append
	puts "Append a value to a key"
	puts "Enter key:"
	key = gets.chomp

	puts "Enter value to append:"
	value = gets.chomp

	puts "#{@redis.append key,value}"
end

#Allows user to store a list 
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

#Gets the list stored in a key and prints the elements out
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

#Allows user to get specific element of a list
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

#Allows user to create a set
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

#Finds the inter section between two sets
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

#Gets the whole set stored in a key
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

#Allows users to find keys based on a pattern
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

#Allows users to renaim the keys
def rename
	puts "Rename a key"
	puts "Enter original key:"
	orginkey = gets.chomp

	puts "Enter new key:"
	newkey = gets.chomp

	begin
		success = @redis.renamenx orginkey,newkey

		success ? "#{puts "rename success"}" : "#{puts "rename fail"}"
	rescue Redis::CommandError => e
		puts "Invalid rename command"
	end
end

#Returns the time on the server
def time
	puts "Get server time"
	puts "Server time is #{@redis.time}"
end

#Gets the type of the value stored at a key
def valType
	puts "Get type of value stored at key"
	puts "Enter key:"
	key = gets.chomp

	puts "Type is: #{@redis.type key}"
end

#Decrements the value stored at a key
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

#Verifies that a set has a specifc element
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

#Removes a number of occurances of an element from a list
def listRemove
	puts "Remove an element and a specified number of occurences from a list"
	puts "Enter key of list:"
	key = gets.chomp

	puts "Enter number of occurences to remove (negative to start at tail,"
	puts "positive to start at head, 0 to remove all occurences"
	occur = gets.chomp

	puts "Enter element to remove occurences of:"
	value = gets.chomp

	begin
		@redis.lrem key, occur, value

	rescue Redis::CommandError => e
		puts "List doesn't exist or it didn't remove the element"
	end
end

#Sets a specified element of a list to a new value
def listSet
	puts "Set an element of a list"

	begin
		puts "Enter key of list:"
		key = gets.chomp
		range = @redis.llen key
		puts "Enter an index between 0 and #{range-1}:"
		index = gets.chomp
		puts "Enter value:"
		value = gets.chomp

		success = @redis.lset key,index,value
		success ? "#{puts "Was able to set the value at #{index} to #{value}"}" :
				"#{puts "Operation failed"}"
	rescue Redis::CommandError => e
		puts "key dosen't map to a list!"
	end
end

#Pops an element off the front of a list
def listPop
	puts "Pop an element of the front of a list"
	puts "Enter key of list:"
	key = gets.chomp

	begin
		element = @redis.lpop key
		element.empty? ? "#{puts "no elements to pop"}" :
					"#{puts "Element poped is: #{element}"}"

	rescue Redis::CommandError => e
		puts "Key doesn't map to list"
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
  puts "S. Remove an element from a list"
  puts "T. Set an element of a list"
  puts "U. Pop an element off the front of a list"
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
  when "S"
  	listRemove
  when "T"
  	listSet
  when "U"
  	listPop
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