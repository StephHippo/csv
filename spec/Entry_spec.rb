SimpleCov.start
require './Entry.rb'
require './EntryValidator.rb'

describe "Entry" do
  before(:each) do
    @val = EntryValidator.new("0123456 LONG            STUART            slong F13 S14")
    @val.validate_entry
    @entry = Entry.new(@val)
  end

  describe "it should convert to a CSV line" do
    it "should return comma separated values" do
      @entry.toCSV.should == "0123456,Long,Stuart,,slong,S14\n"
    end
  end
end