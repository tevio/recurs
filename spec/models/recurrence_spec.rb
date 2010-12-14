require 'spec_helper'

describe Recurs do

end

describe Recurs::Parser do
  #pending "add some examples to (or delete) #{__FILE__}"

  it "should respond to class/module methods:" do
    Recurs::Parser.rrule
    Recurs::Parser.exrule
  end

  it "should get basic rrule" do
    Recurs::Parser.rrule.should == "RRULE:FREQ="
  end

  it "should get basic exrule" do
    Recurs::Parser.exrule.should == "EXRULE:FREQ="
  end

  it "should build a basic daily rule" do
    Recurs::Parser.rrule(:daily).should == "RRULE:FREQ=DAILY"
  end

 it "should create a daily recurrence with a two day interval" do
   Recurs::Parser.rrule(:daily, :interval => 2).should == "RRULE:FREQ=DAILY;INTERVAL=2"
   Recurs::Parser.rrule(:daily, :repeats_every => 2).should == "RRULE:FREQ=DAILY;INTERVAL=2"
   Recurs::Parser.rrule(:daily, :repeats_every => 2, :interval => 2).should == "RRULE:FREQ=DAILY;INTERVAL=2"
 end
#=begin
 it "should create a daily recurrence with a two day interval for ten occurrences" do
   Recurs::Parser.rrule(:daily, :interval => 2, :count => 10).should == "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=10"
   Recurs::Parser.rrule(:daily, :interval => 2, :occurrences => 10).should == "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=10"
   Recurs::Parser.rrule(:daily, :interval => 2, :count => 10, :occurrences => 10).should == "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=10"
 end

 it "should create a valid ending, 'count' OR 'until' NOT both, PREFER 'count'" do
   Recurs::Parser.rrule(:daily, :interval => 2, :count => 10).should == "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=10"
   Recurs::Parser.rrule(:daily, :interval => 2, :ends_at => Date.today).should == "RRULE:FREQ=DAILY;INTERVAL=2;UNTIL=#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}"
   Recurs::Parser.rrule(:daily, :interval => 2, :until => Date.today).should == "RRULE:FREQ=DAILY;INTERVAL=2;UNTIL=#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}"
   Recurs::Parser.rrule(:daily, :interval => 2, :until => Date.today, :count => 10).should == "RRULE:FREQ=DAILY;INTERVAL=2;COUNT=10"
 end
#=end
 it "should create a weekly occurrence" do
   Recurs::Parser.rrule(:weekly).should == "RRULE:FREQ=WEEKLY"
 end  

  it "should build a basic daily rule with a count" do
    Recurs::Parser.rrule(:daily, :count => 10).should == "RRULE:FREQ=DAILY;COUNT=10"
  end

 it "should create a weekly occurrence on monday and thursday" do
   Recurs::Parser.rrule(:weekly, :by_day => [1, 4]).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
   Recurs::Parser.rrule(:weekly, :by_day => [1, '4']).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
   Recurs::Parser.rrule(:weekly, :by_day => ['MO', 'TH']).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
   Recurs::Parser.rrule(:weekly, :by_day => ['Monday', 'THURSDAY']).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
   Recurs::Parser.rrule(:weekly, :by_day => [1, 'TH']).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
   Recurs::Parser.rrule(:weekly, :by_day => [2, 'TH']).should_not == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"

   #Unique
   Recurs::Parser.rrule(:weekly, :by_day => [1, 1, 4, 'TH', 'Thursday', 'MO']).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TH"
 end

  it "should create a weekly occurrence for three weeks" do
   Recurs::Parser.rrule(:weekly, :count => 3).should == "RRULE:FREQ=WEEKLY;COUNT=3"
  end

  it "should create a weekly occurrence for three weeks on fridays" do
   Recurs::Parser.rrule(:weekly, :count => 3, :by_day => 'FR').should == "RRULE:FREQ=WEEKLY;BYDAY=FR;COUNT=3"
    Recurs::Parser.rrule(:weekly, :count => 3, :by_day => :friday).should == "RRULE:FREQ=WEEKLY;BYDAY=FR;COUNT=3"
  end

  it "should create a weekly occurrence for three weeks on fridays and sundays" do
   Recurs::Parser.rrule(:weekly, :count => 3, :by_day => ['FR', 0]).should == "RRULE:FREQ=WEEKLY;BYDAY=FR,SU;COUNT=3"
    Recurs::Parser.rrule(:weekly, :count => 3, :by_day => [:friday, 0]).should == "RRULE:FREQ=WEEKLY;BYDAY=FR,SU;COUNT=3"
  end

  it "should bypass badly input days and use good values" do
   Recurs::Parser.rrule(:weekly, :count => 3, :by_day => ['fer', 0]).should == "RRULE:FREQ=WEEKLY;BYDAY=SU;COUNT=3"
    Recurs::Parser.rrule(:weekly, :count => 3, :by_day => [:fer, 0]).should == "RRULE:FREQ=WEEKLY;BYDAY=SU;COUNT=3"
    Recurs::Parser.rrule(:weekly, :count => 3, :by_day => [:fesefra, :sunday]).should == "RRULE:FREQ=WEEKLY;BYDAY=SU;COUNT=3"
  end

  it "should occur every month" do
   Recurs::Parser.rrule(:monthly).should == "RRULE:FREQ=MONTHLY"
  end

  it "should occur every year" do
    Recurs::Parser.rrule(:yearly).should == "RRULE:FREQ=YEARLY"
  end

  it "should occur every january of each year" do
        Recurs::Parser.rrule(:yearly, :by_month => :january).should == "RRULE:FREQ=YEARLY;BYMONTH=1"
  end

  it "should occur on every thursday of every janruary of each year" do
     Recurs::Parser.rrule(:yearly, :by_month => :january, :by_day => :thursday).should == "RRULE:FREQ=YEARLY;BYMONTH=1;BYDAY=TH"
  end

 it "should have independent instance rules" do
    Recurs::Parser.rrule(:yearly, :by_month => :january).should == "RRULE:FREQ=YEARLY;BYMONTH=1"
    Recurs::Parser.rrule(:weekly, :count => 3, :by_day => ['fer', 0]).should == "RRULE:FREQ=WEEKLY;BYDAY=SU;COUNT=3"
    Recurs::Parser.rrule(:yearly, :by_month => :january).should == "RRULE:FREQ=YEARLY;BYMONTH=1"
 end  
  
end


=begin
# A recurrence instance should implement a couple of attributes ( recurs, rrules, rdates, exrules )

Recurs::Parser.recurs is a composite method combining all rrules and exrules
Recurs::Parser.rrules is an array of rrules similarly exrules is the same

  it "instance should respond to instance methods:" do
    Recurs::Parser = Parser.new
    Recurs::Parser.recurs
    Recurs::Parser.rrules
  end

# The Parser Class should implement singular versions ( rrule, exrule ), these methods generate atomic rules

The Parser class implements the rrule and exrule methods => alias_method_chain perhaps
( these are actually just aliases of the same method but with predefined flags )

=end
