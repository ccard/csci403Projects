#! /usr/bin/ruby
#http://zetcode.com/db/mysqlrubytutorial/
#mysql -h csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com -P3306 -u jsmith -p
require 'mysql'

begin
	con = Mysql.new 'csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com', 'ccard', 'gArfiEld!','snacks'
	rs = con.query 'SELECT name FROM project_test' # rs.each do |row|
							#pust row['key']
	rs.each() do |row|
		printf "%s\n", row[0]
	end

rescue Exception => e
	puts e.errno
	puts e.error

ensure
 con.close if con	
end
