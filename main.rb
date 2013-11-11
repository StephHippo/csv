require 'logger'
require './Entry.rb'

begin

  #get file passed from STDIN
  file = "testcases/example.txt"
  log = Logger.new('log.txt')

  raise "File not found" unless File.exists?(file)
  f = File.open(file)
  #read in each line
  f.each_line do |line|
    #create validator object, pass in line
    entry = Entry.new(line)
    print entry.toCSV
  end

end