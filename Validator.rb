#takes in a line, validates the data, creates an object
require './Entry.rb'

class Validator

  @@status = {:initialized => "INITIALIZED",
              :valid => "VALID",
              :invalid => "INVALID"
  }

  def initialize(line)
    @line = line
    @fields = line.split(" ")
    @first = ""
    @middle = ""
    @last = ""
    @short = ""
    @gradSem = ""
    @id = 0
    @status = @@status[:initialized]
  end

  def create_valid_entry
    Entry.new(@id, @first, @middle, @last, @short, @gradSem) if valid_entry?
  end

  private

  def valid_entry?
    #nominal case
    #Checks for 7 digit ID, Capitalized Last Name, Capitalized First Name, Optional Middle Name, nickname, F13, and then the grad semester
    if line.match(/[\d]{7}\s+[A-Z]*\s+([A-Z]*\s+)?[A-Z]*\s+[a-z]*\s+F13\s+(S|F)\d\d/)
      @id = @fields[0]
      @last = @fields[1].capitalize
      @first = @fields[2].capitalize
      #has a middle name
      if @fields.length == 7
        @middle = @fields[3].capitalize
        @short = @fields[4]
        #skip F13
        @gradSem = @fields[6]
      end
      #has no middle name
      if @fields.length == 6
        @middle = ""
        @short = @fields[3]
        #skip F13
        @gradSem = @fields[5]
      end
    end
  end

end