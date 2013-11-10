#takes in a line, validates the data, creates an object
require './Entry.rb'
#TODO: Move error messaging and logging to Validator instead of main.
class EntryValidator
  attr_reader :status

  @@status = {:initialized => "INITIALIZED",
              :valid => "VALID",
              :invalid => "INVALID"
  }

  def initialize(line, log)
    @log = log
    @line = line
    @fields = line.split(" ")
    @entry = nil
    @id = 0
    @last = ""
    @first = ""
    @middle = ""
    @short = ""
    @gradSem = ""
    @status = @@status[:initialized]
    #TODO: Do I need this?
    @err = InvalidDataError.new
  end

  def get_CSV
    if @status == @@status[:valid]
      ent = create_valid_entry
      ent.toCSV
    else
      log.info("#{status}: #{line}")
    end
  end

  private

  def create_valid_entry
    @entry = Entry.new(@id, @first, @middle, @last, @short, @gradSem)
  end

  def validate_entry
    #nominal case
    #Checks for 7 digit ID, Capitalized Last Name, Capitalized First Name, Optional Middle Name, nickname, F13, and then the grad semester
    if line.match(/[\d]{7}\s+[A-Z]*\s+[A-Z]*\s+([A-Z]*\s+)?[a-z]*\s+F13\s+(S|F)\d\d/) then
      set_fields
    else
      validate_fields
    end
    @status
  end

  def set_fields
    @id = @fields[0]
    @last = @fields[1]
    @first = @fields[2]
    if @fields.length == 7
      @middle = @fields[3]
      @short = @fields[4]
      #skip F13
      @gradSem = @fields[6]
    else
      @middle = ""
      @short = @fields[3]
      #skip F13
      @gradSem = @fields[5]
    end
    @status = @@status[:valid]
  end

end