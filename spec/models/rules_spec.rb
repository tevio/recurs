require 'spec_helper'
describe Recurs::Rules do
  it "should respond to class/module variables" do
    Recurs::Rules.repeat_procs
    Recurs::Rules.schemes
  end

    it "should build Daily" do
      Recurs::Rules.repeat_procs['Daily'].call(true, :count => 10).should == "RRULE:FREQ=DAILY;COUNT=10"
    end
#=begin
    it 'Every Weekday ( Mon - Fri )' do
      Recurs::Rules.repeat_procs['Every Weekday ( Mon - Fri )'].call(true, :count => 10).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR;COUNT=10"
    end

    it 'Every Mon, Wed, Fri' do
      Recurs::Rules.repeat_procs['Every Mon, Wed, Fri'].call(true, :count => 10).should == "RRULE:FREQ=WEEKLY;BYDAY=MO,WE,FR;COUNT=10"
    end

    it 'Every Tues, Thurs' do
      Recurs::Rules.repeat_procs['Every Tues, Thurs'].call(true, :count => 10).should == "RRULE:FREQ=WEEKLY;BYDAY=TU,TH;COUNT=10"
    end

    it 'Every Weekend' do
      Recurs::Rules.repeat_procs['Every Weekend'].call(true, :count => 10).should == "RRULE:FREQ=WEEKLY;BYDAY=SU,SA;COUNT=10"
    end

    it 'Weekly' do
      Recurs::Rules.repeat_procs['Weekly'].call(true, :count => 10).should == "RRULE:FREQ=WEEKLY;COUNT=10"
    end

    it 'Monthly' do
      Recurs::Rules.repeat_procs['Monthly'].call(true, :count => 10).should == "RRULE:FREQ=MONTHLY;COUNT=10"
    end

    it 'Yearly' do
      Recurs::Rules.repeat_procs['Yearly'].call(true, :count => 10).should == "RRULE:FREQ=YEARLY;COUNT=10"
    end
#=end
end