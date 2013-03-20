#! /usr/bin/ruby
#http://zetcode.com/db/mysqlrubytutorial/
#mysql -h csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com -P3306 -u jsmith -p
require 'mysql'

begin
	con = Mysql.new 'csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com', 'ccard', 'gArfiEld!'
	puts con.get_server_info
	con.query 'USE snacks'
	rs = con.query 'SELECT name FROM project_test' # rs.each do |row|
							#pust row['key']
	#puts rs.fetch_row
rescue Exception => e
	puts e.errno
	puts e.error

ensure
 con.close if con	
end
