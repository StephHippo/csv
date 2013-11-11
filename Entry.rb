class Entry

  @@log = Logger.new('log.txt')

  @@status = {
      :INITIALIZED => "INITIALIZED",
      :VALID => "VALID",
      :INVALID => "INVALID",
      :BADID => "ID OUTSIDE RANGE",
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

  def toCSV
    validate_entry
    if @status == @@status[:VALID]
      @@log.info("Successfully converted #{@line} to CSV format")
      "#{@id},#{@last.capitalize},#{@first.capitalize},#{@middle.capitalize},#{@short.downcase},#{@gradSem}\n"
    else
      ""
    end
  end

  private

  def validate_entry
    if @line.match(/[\d]{7}\s+[A-Za-z]*\s+[A-Za-z]*\s+([A-Za-z]*\s+)?[A-Za-z]*\s+F13\s+(S|F)\d\d/)
      set_fields
      @status = @@status[:VALID]
    else
      sanitize_fields
      @@log.info("#{@status} : #{@line}") unless @status == "VALID"
    end
  end

  #validate the id field, the name fields, and the grad semester
  def sanitize_fields
    sanitize_id
    sanitize_names
    sanitize_grad_sem
  end

  #shouldn't rescue ids as we would be unable to guarantee they would remain unique without performance repercussions
  def sanitize_id
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
  def sanitize_names
    if @status == @@status[:VALID]
      names = @line.scan(/\d\s.*\s.*\s.*\s.*F13/)[0].split(" ")
      names.delete(names.last)
      names.delete(names.first)
      names = remove_invalid_chars(names)
      set_names(names)
      @@log.info("WARNING: Attempted rescue of name values from #{names} to last: #{@last}, first: #{@first}, middle: #{@middle}, short: #{@short}.")
    end
  end

  #look for alternate inputs that could mean Fall or Spring and appropriate year
  def sanitize_grad_sem
    if @status == @@status[:VALID]
      gradsem = @fields.last
      (gradsem =~ /[F|S]\d\d/) ? @gradSem = gradsem : @status = @@status[:BADGRADSEM]
      map_grad_sem(gradsem)
    end
  end

  def set_fields
    @id = @fields.first
    names = @fields[1...@fields.length-2]
    set_names(names)
    @gradSem = @fields.last
  end

  def set_names(names)
    #if there is no middle name
    if names.length == 3
      @last = names[0]
      @first = names[1]
      @short = names[2]
      @status = @@status[:VALID]
      #when there is a middle name
    elsif names.length == 4
      @last = names[0]
      @first = names[1]
      @middle = names[2]
      @short = names[3]
      @status = @@status[:VALID]
    else
      @status = @@status[:BADNAME]
    end
  end

  #removes any non-friendly name characters
  def remove_invalid_chars(names)
    names.each do |name|
      name.gsub!(/[^A-Za-z'-]/, "")
    end
    names
  end

  #try to map the gradsem input values to valid fields
  def map_grad_sem(gradsem)
    semester_map = ["Fall", "fall", "f", "F", "Spring", "spring", "s", "S"]

    if @status == @@status[:BADGRADSEM]
      semester_map.each do |sem|
        if (gradsem.start_with? sem) && (@status != @@status[:VALID])
          semester = sem[0].upcase
          yr = gradsem.scan(/\d\d/).last
          @gradSem = "#{semester}#{yr}"
          @@log.info("WARNING: Attempted rescue of gradSem from #{gradsem} to #{@gradSem}")
          @status = @@status[:VALID]
        end
      end
    end
  end

end