#http://zetcode.com/db/mysqlrubytutorial/
#mysql -h csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com -P3306 -u jsmith -p
require 'mysql'

begin
	con = Myswl.new 'localhost', 'ccard', 
rescue Exception => e
	puts e.errno
	puts e.error

ensure
 con.close if con	
end