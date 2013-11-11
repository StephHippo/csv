class Entry
  attr_reader :status

  @@status = {
      :INITIALIZED => "INITIALIZED",
      :VALID => "VALID",
      :INVALID => "INVALID",
      :BADID => "ID OUTSIDE RANGE",
      :NOID => "NO ID FOUND",
      :BADNAME => "MISSING PART OR ALL OF THE NAME",
      :BADSHORT => "SHORT NAME IS MISSING",
      :BADGRADSEM => "DOES NOT FOLLOW SPRING/FALL YEAR FORMAT"
  }

  def initialize(line, log)
    @line = line
    @fields = line.split(" ")
    @id = 0
    @first = ""
    @middle = ""
    @last = ""
    @short = ""
    @gradSem = ""
    @status = @@status[:INITIALIZED]
    @log = log
  end

  #public methods check and sanitize data
  def validate_entry
    if @line.match(/[\d]{7}\s+[A-Za-z]*\s+[A-Za-z]*\s+([A-Za-z]*\s+)?[A-Za-z]*\s+F13\s+(S|F)\d\d/)
      set_fields
      @status = @@status[:VALID]
    else
      validate_fields
      @log.info("#{@status} : #{@line}") unless @status == "VALID"
    end
  end

  def toCSV
    if @status == @@status[:VALID]
      @log.info("Successfully converted #{@line} to CSV format")
      "#{@id},#{@last.capitalize},#{@first.capitalize},#{@middle.capitalize},#{@short.downcase},#{@gradSem}\n"
    else
      @log.info("#{@status}: #{@line}")
      ""
    end
  end

  private

  def set_fields
    @id = @fields.first
    names = @fields[1...@fields.length-2]
    set_names(names)
    @gradSem = @fields.last
  end

  def set_names(names)
    if names.length == 3
      @last = names[0]
      @first = names[1]
      @short = names[2]
    end
    if names.length == 4
      @last = names[0]
      @first = names[1]
      @middle = names[2]
      @short = names[3]
    end
  end

  #validate the id field, the name fields, and the grad semester
  def validate_fields
    validate_id
    validate_names
    validate_grad_sem
  end

  #shouldn't rescue ids as we would be unable to guarantee they would remain unique without performance repercussions
  def validate_id
    id = @fields.first
    if @status == @@status[:INITIALIZED]
      if id.length == 7
        #id was valid. problem is somewhere else in the entry
        @id = id
        @status = @@status[:VALID]
      else
        @status = @@status[:BADID]
      end
    end
  end

  #rescue and sanitize what we can
  #TODO: Not always guaranteed to solve. condition the changing of :VALID set
  def validate_names
    if @status == @@status[:VALID]
      @status = @@status[:BADNAME]
      names = @line.scan(/\d\s.*\s.*\s.*\s.*F13/)[0].split(" ")
      names.delete(names.last)
      names.delete(names.first)
      names = remove_invalid_chars(names)
      set_names(names)
      @status = @@status[:VALID]
      @log.info("WARNING: Attempted rescue of name values from #{names} to last: #{@last}, first: #{@first}, middle: #{@middle}, short: #{@short}.")
    end
  end

  #removes any non-friendly name characters
  def remove_invalid_chars(names)
    names.each do |name|
      name.gsub!(/[^A-Za-z'-]/, "")
    end
    names
  end

  #look for alternate inputs that could mean Fall or Spring
  def validate_grad_sem
    if @status == @@status[:VALID]
      gradsem = @fields.last

      #assume we won't rescue the gradsem
      if gradsem =~ /[F|S]\d\d/
        @gradSem = gradsem
      else
        semesterMap = {"Fall" => "F", "fall" => "F", "f" => "F",
                       "Spring" => "S", "spring" => "S", "s" => "S"}
        @status = @@status[:BADGRADSEM]

        #if we can rescue the grad sem, reset the status
        semesterMap.each do |k,v|
          if gradsem.include? k
            sem = v
            yr = gradsem.scan(/\d\d/).last
            @gradSem = "#{sem}#{yr}"
            @log.info("WARNING: Attempted rescue of gradSem from #{gradsem} to #{@gradSem}")
            @status = @@status[:VALID]
          end
        end
      end
      if @status != @@status[:VALID]
        @gradSem = "UNKNOWN"
        @status = @@status[:VALID]
        @log.info("WARNING: Unable to identify the graduation semester, set to unknown.")
      end
    end
  end

end