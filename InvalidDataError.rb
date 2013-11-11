class InvalidDataError < StandardError
  attr_reader :message

  def initialize(message = nil)
    @message = message
  end

  def check_valid(field, statusmsg)
    raise UninitializedObjectError.new "Invalid Data Error: #{field}"
  end
end