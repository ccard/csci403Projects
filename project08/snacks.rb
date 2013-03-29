#!/usr/bin/env ruby

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
  has_many :machines

end

#------------------------------------------------------------------
# This class is for the machines table in data base
class Machine < ActiveRecord::Base
  belongs_to :building
  has_and_belongs_to_many :snacks #auto joins the two tables based on machines_tables
end

#------------------------------------------------------------------
# This class is for the snacks table in the data base
class Snack < ActiveRecord::Base
  has_and_belongs_to_many :machines #auto joins the two tables based on machines_tables
  has_and_belongs_to_many :users

  validates :caloires, :numericality => { :greater_than => -1}
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
#in
def find_snack
  puts "What snack do you want to find?"
  name = gets
  snacks = Snack.find_all_by_name name.gsub("\n","")
  snacks.each do |snack|
    snack.machines.each do |machine|
      puts "In machine #{machine.serial_number} located in #{machine.building.name} building"
    end
  end

#------------------------------------------------------------------
# This lists all snacks and machines that they are related to
def add_snack
  

end

rescue Exception => e 
  puts "There is no such snack '#{name.gsub("\n","")}' in the system!"
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
    # TDOO add_snack
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