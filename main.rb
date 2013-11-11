require 'logger'
require './Entry.rb'
require './EntryValidator.rb'

begin

  #read in each line
  STDIN.each_line do |line|
    #create validator object, pass in line
    val = EntryValidator.new(line)
    if val.validate_entry == "VALID"
      entry = Entry.new(val)
      STDOUT.print entry.toCSV
    end
  end

end