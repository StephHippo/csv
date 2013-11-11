require 'logger'
require './Entry.rb'

begin

  #get file passed from STDIN
  file = "testcases/example.txt"
  log = Logger.new('log.txt')

  if File.exists?(file)
    #open file
    f = File.open(file)
    #read in each line
    f.each_line do |line|
      #create validator object, pass in line
      entry = Entry.new(line, log)
      entry.validate_entry
      puts entry.toCSV
    end
  else
    log.info("#{file} is not a valid file.")
  end

  #close logger
  log.close

end