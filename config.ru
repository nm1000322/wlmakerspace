require 'bundler'
Bundler.require

require './app.rb'
DB = Sequel.connect(ENV['DATABASE_URL'])
require './models.rb'
DB.disconnect

run WLMS