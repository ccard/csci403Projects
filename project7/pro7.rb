#! /usr/bin/ruby
#http://zetcode.com/db/mysqlrubytutorial/
#mysql -h csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com -P3306 -u jsmith -p
require 'mysql'

begin
	#Creates a new connection to sever <location>,<user>,<pass>,<database>
	con = Mysql.new 'csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com', 'ccard', 'gArfiEld!','snacks'

	#queries the db for names in project_test and gets the result set
	rs = con.query 'SELECT name FROM project_test' 

	#this iterates through each row storing each row into row
	rs.each() do |row|
		printf "%s\n", row[0] #prints out the name
	end

#error catching for exception
rescue Exception => e
	puts e.errno
	puts e.error

ensure #like finally always ensures that connection is closed
	#closes connection if conection exists
	con.close if con	
end
