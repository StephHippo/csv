require 'logger'
require './EntryValidator.rb'
require './Entry.rb'

begin

  #get file passed from STDIN
  file = ARGV[0]
  log = Logger.new('log.txt')

  if File.exists?(file)
    #open file
    file.open
    #read in each line
    file.each_line do |line|
      #create validator object, pass in line
      entry = Entry.new(line)
      if val.status == "VALID"

      end
    end
  else
    log.info("#{file} is not a valid file.")
  end

  #close logger
  log.close

end