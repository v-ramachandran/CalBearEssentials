#!/usr/bin/env ruby

require "csv"

CSV_FILE_PATH = "test.csv"
BASE_DIR='db/init_data/'

=begin
CSV.foreach( CSV_FILE_PATH, :headers => :first_row, :header_converters => :symbol, :converters => :numeric ) do |line|
  puts line.to_hash.to_s
  print line.to_hash.to_s
end
=end

Dir.foreach(BASE_DIR) do |ln|
  unless File.directory? ln
    puts ln.to_s.split(/\./).to_s
  end
end

