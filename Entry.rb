class Entry

  def initialize(id, first, middle, last, short, gradSem)
    @id = id
    @first = first
    @middle = middle
    @last = last
    @short = short
    @gradSem = gradSem
  end

  def toCSV
    @id<<","<<@last<<","<<@first<<" "<<@middle<<","<<@short<<","<<@gradSem<<"\n"
  end

end