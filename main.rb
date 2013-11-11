require 'logger'
require './Entry.rb'
require './EntryValidator.rb'

begin

  #unless ARGV[0].nil? || ARGV[1].nil?
  #  k = ARGV[0].to_i
  #  file = ARGV[1]
  #else
  #  puts "What is the value of k?"
  #  k = gets
  #  k = k.to_i
  #  puts "What is the name of the file?"
  #  file = gets
  #  file = file.delete("\n")
  #end


  #get file passed from STDIN
  file = "testcases/example.txt"
  log = Logger.new('log.txt')

  raise "File not found" unless File.exists?(file)
  f = File.open(file)
  #read in each line
  f.each_line do |line|
    #create validator object, pass in line
    val = EntryValidator.new(line)
    if val.validate_entry == "VALID"
      entry = Entry.new(val)
      print entry.toCSV
    end
  end

end