class Entry
  attr_reader :status

  @@status = {
      :INITIALIZED => "INITIALIZED",
      :VALID => "VALID",
      :INVALID => "INVALID",
      :BADID => "NO ID FOUND OR ID TOO SHORT",
      :BADNAME => "MISSING PART OR ALL OF THE NAME",
      :BADSHORT => "SHORT NAME IS MISSING",
      :BADGRADSEM => "DOES NOT FOLLOW SPRING/FALL YEAR FORMAT"
  }

  def initialize(line)
    @line = line
    @fields = line.split(" ")
    @id = 0
    @first = ""
    @middle = ""
    @last = ""
    @short = ""
    @gradSem = ""
    @status = @@status[:INITIALIZED]
  end

  #public methods check and sanitize data
  def validate_entry
    if @line.match(/[\d]{7}\s+[A-Za-z]*\s+[A-Za-z]*\s+([A-Za-z]*\s+)?[A-Za-z]*\s+F13\s+(S|F)\d\d/)
      set_fields
      @status = @@status[:valid]
    else
      validate_fields
    end
  end

  private

  def toCSV
    if @status == @@status[:valid]
      "#{@id},#{@last.capitalize},#{@first.capitalize} #{@middle.capitalize},#{@short.downcase},#{@gradSem}\n"
    end
  end

  #TODO: Rename to describe that set_fields is for the nominal case
  def set_fields
    @id = @fields[0]
    @last = @fields[1]
    @first = @fields[2]
    if @fields.length == 7
      @middle = @fields[3]
      @short = @fields[4]
      #Skip F13
      @gradSem = @fields[6]
    end
    if @fields.length == 6
      @middle = ""
      @short = @fields[3]
      #Skip F13
      @gradSem = @fields[5]
    end
  end

  #determine what's bad and what's good
  def validate_names
    if @fields.length == 6

    elsif @fields.length == 7

    else

    end
  end

  def validate_grad_sem

  end

end