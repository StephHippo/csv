require 'simplecov'
SimpleCov.start
require './EntryValidator.rb'

#Tested public methods only
describe "Entry_Validator" do
  describe "validate_entry" do
    #GOOD DATA
    it "should return valid when given a properly formatted string" do
      @val = EntryValidator.new("0123456 LONG            STUART            slong F13 S14")
      @val.validate_entry.should == "VALID"
    end

    #BAD DATA
    it "should return a status message when given a properly formatted string" do
      @val = EntryValidator.new("012a456 LONG            STUART            slong F13 S14")
      !(@val.validate_entry.should == "VALID")
    end
  end

  describe "sanitize_fields" do
    it "should make all the fields in an entry valid" do
      @val = EntryValidator.new("0123456 LONG            STUART            slong F13 Spring14")
      @val.sanitize_id
      @val.status.should == "VALID"
    end
  end

  describe "sanitize_id" do
    it "should check if the id is valid and return BADID if the id is invalid." do
      @val = EntryValidator.new("01256 LONG            STUART            slong F13 Spring14")
      @val.sanitize_id
      @val.status.should == "ID OUTSIDE RANGE"
    end

    it "should leave the id alone if valid" do
      @val = EntryValidator.new("0123456 LONG            STUART            slong F13 S14")
      @val.sanitize_id
      @val.status.should == "VALID"
    end
  end

  describe "sanitize_names" do
    it "sanitize invalid characters from names" do
      @val = EntryValidator.new("0123456 LO!NG            ST?UART            slong F13 S14")
      @val.sanitize_id
      @val.status.should == "VALID"
    end
  end

  describe "sanitize_grad_sem" do
    it "maps possible common errors to valid entries" do
      @val = EntryValidator.new("0123456 LONG            STUART            slong F13 Spring14")
      @val.sanitize_id
      @val.sanitize_grad_sem
      @val.status.should == "VALID"
    end

    it "sets the status to a BADGRADSEM if it cannot be rescued" do
      @val = EntryValidator.new("0123456 LONG            STUART            slong F13 X14")
      @val.sanitize_id
      @val.sanitize_grad_sem
      @val.status.should == "DOES NOT FOLLOW SPRING/FALL YEAR FORMAT"
    end
  end
end

