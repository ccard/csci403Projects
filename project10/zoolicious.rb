#! usr/bin/env ruby
#Chris Card

require 'mongo'
require 'uri'

MONGO_URL='mongodb://junk@humanoriented.com:wuwnosql403@staff.mongohq.com:10033/zoolicious'
db = URI.parse(ENV[MONGO_URL])
db_name = db.path.gsub('/^\//','')
@connect = Mongo::Connection.new(db.host,db.port).db(db_name)
@connect.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)


@connect.close