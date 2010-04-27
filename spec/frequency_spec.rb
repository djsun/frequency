require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Frequency" do

  describe "quarterly" do
    before do
      @freq = Frequency.new("quarterly")
    end

    it "should be valid" do
      @freq.plain_text.should == "quarterly"
    end
  
    it "should be valid" do
      @freq.valid?.should be_true
    end

    it "#per_year should be correct" do
      @freq.per_year.should == 4.0
    end

    it "#per_decade should be correct" do
      @freq.per_decade.should == 40
    end
    
    it "should be < monthly" do
      @freq.should < Frequency.new('monthly')
    end

    it "should be <= monthly" do
      @freq.should <= Frequency.new('monthly')
    end

    it "should be <= each quarter" do
      @freq.should <= Frequency.new('each quarter')
    end

    it "should be == each quarter" do
      @freq.should == Frequency.new('each quarter')
    end

    it "should be >= quarterly" do
      @freq.should >= Frequency.new('quarterly')
    end

    it "should be > annually" do
      @freq.should > Frequency.new('annually')
    end
  end

  describe "Monthly" do
    before do
      @freq = Frequency.new("Monthly")
    end

    it "should be valid" do
      @freq.plain_text.should == "monthly"
    end

    it "should be valid" do
      @freq.valid?.should be_true
    end

    it "#per_year should be correct" do
      @freq.per_year.should == 12.0
    end
  end
  
  describe "nil" do
    before do
      @freq = Frequency.new(nil)
    end

    it "should be valid" do
      @freq.plain_text.should == ""
    end
  end
  
  describe "sometimes" do
    before do
      @freq = Frequency.new("sometimes")
    end
    
    it "should be invalid" do
      @freq.valid?.should be_false
    end

    it "#per_year should be nil" do
      @freq.per_year.should == nil
    end

    it "#per_decade should be nil" do
      @freq.per_decade.should == nil
    end

    it "< should be undefined" do
      lambda {
        @freq.should < Frequency.new('monthly')
      }.should raise_error(Frequency::Undefined)
    end

    it "<= should be undefined" do
      lambda {
        @freq.should <= Frequency.new('monthly')
      }.should raise_error(Frequency::Undefined)
    end
    
    it "== should be undefined" do
      lambda {
        @freq.should == Frequency.new('monthly')
      }.should raise_error(Frequency::Undefined)
    end

    it ">= should be undefined" do
      lambda {
        @freq.should >= Frequency.new('monthly')
      }.should raise_error(Frequency::Undefined)
    end
    
    it "> should be undefined" do
      lambda {
        @freq.should > Frequency.new('monthly')
      }.should raise_error(Frequency::Undefined)
    end
  end
  
  # ---
  
  describe "list" do
    it "should be correct" do
      Frequency.list.should == [
        "each second",
        "each minute",
        "hourly",
        "daily",
        "weekly",
        "fortnightly",
        "monthly",
        "quarterly",
        "biannually",
        "annually",
        "biennially",
        "quadrennially",
        "each decade",
        "one time",
        "other",
        "unknown"
      ]
    end
  end
  
end
