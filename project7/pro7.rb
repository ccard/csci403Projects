#http://zetcode.com/db/mysqlrubytutorial/
#mysql -h csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com -P3306 -u jsmith -p
require 'mysql'

begin
	con = Myswl.new ' csci403.c99q7trvwetr.us-west-2.rds.amazonaws.com', 'ccard', 'password here'
	puts con.get_server_info
	rs = con.query 'statements'
	puts rs.fetch_row
rescue Exception => e
	puts e.errno
	puts e.error

ensure
 con.close if con	
end