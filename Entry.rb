require './EntryValidator.rb'

class Entry

  def initialize(val)
    @id = val.id
    @first = val.first
    @middle = val.middle
    @last = val.last
    @short = val.short
    @gradSem = val.gradSem
  end

  def toCSV
    "#{@id},#{@last.capitalize},#{@first.capitalize},#{@middle.capitalize},#{@short.downcase},#{@gradSem}\n"
  end
end