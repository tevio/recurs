module Recurs
  module Rules
  mattr_accessor :repeat_procs, :schema
  @@repeat_procs = {

=begin
    'Daily' => ->(args = {}){
        args[:repeats] = 'DAILY'
        rrule(args);
    }, # 0
=end

#=begin
    'Daily' => ->(set=false, args = {}){
      unless set
        @recurrence_template = ['standard','Days']
      else
        Parser.rrule(:daily, args)
      end;
    }, # 0
#=end

    'Every Weekday ( Mon - Fri )' => ->(set=false, args = {}){
      unless set
        @recurrence_template = 'set_points'
      else
        args[:by_day] = [1,2,3,4,5]
        Parser.rrule(:weekly, args)
        #
        # .
      end;
    }, # 1

    'Every Mon, Wed, Fri' => ->(set=false, args = {}){
      unless set
        @recurrence_template = 'set_points'
      else
        args[:by_day] = [1,3,5]
        Parser.rrule(:weekly, args)
      end;
    }, # 2

    'Every Tues, Thurs' => ->(set=false, args = {}){
      unless set
        @recurrence_template = 'set_points'
      else
        args[:by_day] = [2,4]
        Parser.rrule(:weekly, args)
      end;
    }, # 3

    'Every Weekend' => ->(set=false, args = {}){
      unless set
        @recurrence_template = 'set_points'
      else
        args[:by_day] = [0,6]
        Parser.rrule(:weekly, args)
      end;
    }, # 4

    'Weekly' => ->(set=false, args = {}){
      unless set
        @recurrence_template = ['weekly', 'Weeks']
      else
        Parser.rrule(:weekly, args)
      end;
    }, # 5

    'Monthly' => ->(set=false, args = {}){
      unless set
        @recurrence_template = ['monthly', 'Months']
      else
        Parser.rrule(:monthly, args)
      end;
    }, # 6

    'Yearly' => ->(set=false, args = {}){
      unless set
        @recurrence_template = ['standard', 'Years']
      else
        Parser.rrule(:yearly, args)
      end;
    } # 7

  }
  class << self
    def schemes
      @@schemas = @@repeat_procs.keys if @@repeat_procs.is_a? Hash
    end
  end
  end
end