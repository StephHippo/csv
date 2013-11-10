class InvalidDataError < StandardError
  attr_reader :message

  def initialize(message = nil)
    @message = message
  end

  def check_initialized(obj)
    unless obj.valid
      raise UninitializedObjectError.new "Uninitialized object: #{obj.inspect}"
    end
  end
end