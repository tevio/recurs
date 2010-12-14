require 'spec_helper'

class Event;end
Event.send(:include, Recurs::Parser)
class Event
  acts_as_recurring
end

describe Event do
  before :each do
    @event = Event.new
  end

  it "should act as recurring" do
    #@event.rrules
    #@event.exrules
    #@event.rdates
    #@event.exdates
    @event.recurs
  end

  it "should add an rrule" do
    @event.add_rrule(:daily).should == "RRULE:FREQ=DAILY"
    @event.recurs.should == "RRULE:FREQ=DAILY"
  end

  it "should add a non specific rule" do
    @event.add_rule(:daily).should == ":FREQ=DAILY"
    @event.recurs.should == ":FREQ=DAILY"
  end

  it "should add an exrule" do
    @event.add_exrule(:daily).should == "EXRULE:FREQ=DAILY"
    @event.recurs.should == "EXRULE:FREQ=DAILY"
  end

  it "should render a correct ical string" do
    @event.add_rrule(:daily).should == "RRULE:FREQ=DAILY"
    @event.add_exrule(:daily).should == "EXRULE:FREQ=DAILY"
    @event.recurs.should == "RRULE:FREQ=DAILY\nEXRULE:FREQ=DAILY"
  end

  it "should add an rdate" do
    @event.add_rdate(Date.today).should == "RDATE:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}"
  end

  it "should add an rdate range" do
    @event.add_rdate(:period => [Date.today, (Date.today+2)]).should == "RDATE;VALUE=PERIOD:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}/#{RiCal::FastDateTime.from_date_time((Date.today+2).to_datetime).ical_str}"
  end
  it "should add a list of rdates" do
    @event.add_rdate(:dates => [Date.today, (Date.today+2)]).should == "RDATE:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str},#{RiCal::FastDateTime.from_date_time((Date.today+2).to_datetime).ical_str}"
  end
  it "should add an exdate" do
    @event.add_exdate(Date.today).should == "EXDATE:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}"
  end

  it "should add an exdate range" do
    @event.add_exdate(:period => [Date.today, (Date.today+2)]).should == "EXDATE;VALUE=PERIOD:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str}/#{RiCal::FastDateTime.from_date_time((Date.today+2).to_datetime).ical_str}"
  end
  it "should add a list of exdates" do
    @event.add_exdate(:dates => [Date.today, (Date.today+2)]).should == "EXDATE:#{RiCal::FastDateTime.from_date_time(Date.today.to_datetime).ical_str},#{RiCal::FastDateTime.from_date_time((Date.today+2).to_datetime).ical_str}"
  end


end

=begin
  An event has recurrence

  @event.recurs #"DTSTART;TZID=US-Eastern:19970902T0900
                  RRULE:FREQ=DAILY;COUNT=10
                  EXRULE:"

TODO: Ascertain how ri_cal parses complex rules

While building the recurrence the event must use private instance attributes from the recurrrence module:

The recurrence module must be mixed into the model transparently, either by using an acts_as
or by inheriting from the module

class Event < AR
acts_as_recurring_event
end

=end