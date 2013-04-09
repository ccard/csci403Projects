#! /user/bin/env ruby

#Chris Card
#Project 9

require "redis"

@redis = Redis.new :host => "pub-redis-13059.us-west-1.1.azure.garantiadata.com", :port => 13059, :password => "wuwnosql403"


def find
	puts "Find by key:"
	puts "Enter key:"
	key = gets.chomp
	puts "#{@redis.get key}"

end

def add
	puts "Add an element"
	puts "Enter key:"
	key = gets.chomp
	puts "Enter value:"
	value = gets.chomp
	@redis.set key, value
end

def incer
	puts "Increase count"
	@redis.incr "count"
	puts "count is now => #{@redis.get "count"}"
end

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


def main_menu
  puts "\nMain Menu."
  puts "A. Find obj"
  puts "B. Add obj"
  puts "C. Increment count"
  puts "D. Add multiple objects"
  puts "E. Find a Snack"
  puts "F. Add a New Snack"
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
  #when "E"
  #  puts "\nFind a Snack"
  #  find_snack
  #when "F"
  #  puts "\nAdding a new Snack"
  #  add_snack
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