#!/usr/bin/env ruby

#Chirs Card
#Added code to boiler plate

require 'rubygems'
require 'active_record'
require 'logger'

#
# Configuration
#
#ActiveRecord::Base.logger = Logger.new(STDOUT) # Comment this line to turn off log output
ActiveRecord::Base.establish_connection(
  :host => 'csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com',
  :username => 'ccard',
  :password => 'gArfiEld!',
  :adapter => 'mysql2',
  :database => 'snacks'
)

#
# Class definitions
#
class User < ActiveRecord::Base
  has_and_belongs_to_many :snacks
  def to_s
    name
  end

end


# TODO: Your class definitions should be placed here.

#------------------------------------------------------------------
# This class is for buildings table from the data base
class Building < ActiveRecord::Base
  has_many :machines #many side of one to many
end

#------------------------------------------------------------------
# This class is for the machines table in data base
class Machine < ActiveRecord::Base
  belongs_to :building #one side of one to many
  has_and_belongs_to_many :snacks #auto joins the two tables based on machines_tables
end

#------------------------------------------------------------------
# This class is for the snacks table in the data base
class Snack < ActiveRecord::Base
  has_and_belongs_to_many :machines #auto joins the two tables based on machines_tables
  has_and_belongs_to_many :users #auto joins the two tables based on machines_tables

  #validation of calories has to be numeric and greater than one or not valid entry
  validates :calories, :numericality => { :greater_than => -1}
  #name has to be at least length 1 and can't be blank
  validates :name, :length => {:minimum => 1}, :allow_blank => false
end


#
# Core functions.
#
def list_users
  users = User.all
  users.each do |user|
    puts user
  end
end

# TODO: Your other menu-driven functions should be placed here.

#------------------------------------------------------------------
# This lists all buildings and number of machines they have
def list_buildings
  buildings = Building.all
  buildings.each do |building|
    puts "#{building.name} (#{building.machines.count} machines)"
  end
end

#------------------------------------------------------------------
# This lists machines their description and what building their in
def list_machines
  machines = Machine.all
  machines.each do |machine|
    puts "#{machine.serial_number}, #{machine.description} (#{machine.building.name})"
  end
end

#------------------------------------------------------------------
# This lists all snacks and machines that they are related to
def list_snacks
  snacks = Snack.all
  snacks.each do |snack|
    puts "#{snack.name}"
    snack.machines.each do |machine|
      puts "- #{machine.serial_number} in #{machine.building.name}"
    end
  end
end

#------------------------------------------------------------------
# This finds the snack and lists all buildings and machines that its
# in
def find_snack
  puts "What snack do you want to find?"
  name = gets.chomp

  #returns the list of all snacks with the name of name 
  #(string is read in with \n had to remove it)
  snacks = Snack.find_all_by_name name

  #if the snacks list is empty then prints out not found error other wise iterate over the
  #list
  snacks.empty? ? "#{puts "There is no such snack '#{name}' in the system!"}" : 
  snacks.each do |snack|
    snack.machines.each do |machine|
      puts "In machine #{machine.serial_number} located in #{machine.building.name} building"
    end
  end
end


#------------------------------------------------------------------
# This adds a new snack to the database or it doesn't if the
# provided calories is negative
def add_snack
  puts "Snack's name:"
  name = gets.chomp
  
  puts "Snack's manufacturer:"
  manuf = gets.chomp

  puts "Snack's calories:"
  cal = gets.chomp

  #lists all machines for user to select from
  puts "Machines:"
  machines = Machine.all
  machines.each do |machine|
    puts "id: #{machine.id} => machine #{machine.serial_number} located at #{machine.description} in #{machine.building.name}"
  end
  puts "Enter machines id number:"
  id = gets.chomp

  #creates a new snack
  snack = Snack.create :name => name, :description => manuf, :calories => cal
  machine = Machine.find id
  snack.machines << machine

  success = "Success: snack added to database!"
  #This is the fail method only has a conditional in it so it doesn't create errors
  fail = "Fail: #{snack.valid? ? "" : "calories can't be negative : name cant be blank" }: 
          snack not added to database!"

  #writes out success or fail depending on the validity of snack
  puts snack.valid? ? success : fail
end

def main_menu
  puts "\nMain Menu."
  puts "A. List Buildings"
  puts "B. List Machines"
  puts "C. List Snacks"
  puts "D. List Users"
  puts "E. Find a Snack"
  puts "F. Add a New Snack"
  puts "Q. Quit"
end

def execute_command(command)
  case command
  when "A"
    puts "\nListing Buildings"
    list_buildings
  when "B"
    puts "\nListing Machines"
    list_machines
  when "C"
    puts "\nListing Snacks"
    list_snacks
  when "D"
    puts "\nListing Users"
    list_users
  when "E"
    puts "\nFind a Snack"
    find_snack
  when "F"
    puts "\nAdding a new Snack"
    add_snack
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