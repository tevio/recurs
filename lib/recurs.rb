require 'util/module' unless defined? Rails
require 'recurs/consts'
require 'recurs/rules'
require 'ri_cal'
module Recurs
  include RiCal
  # Your code goes here...

  module Parser

    def self.included(base)
      base.send :extend, ClassMethods
    end

    # class << self is NOT the same as including ( seen above ) which makes methods available to CLASSES that include the module
    #, it ONLY makes the methods available to the MODULE itself
    class << self
      def rrule(repeats=nil, args={})
        args[:rule] = :r
        rule(repeats, args)
      end

      def exrule(repeats=nil, args={})
        args[:rule] = :e
        rule(repeats, args)
      end

      def rdate(dates=nil, args={})
        args[:rule] = :r
        date(dates, args)
      end

      def exdate(dates=nil, args={})
        args[:rule] = :e
        date(dates, args)
      end

      def date(dates=nil, args={})
        args[:rule] == :r ? r = "RDATE" : r = "EXDATE"
        if dates.is_a? Hash
          f_dates = dates.flatten
          if (f_dates[0] == :period) || (f_dates[0] == :range)
            r += ";VALUE=PERIOD:"
            i = 0
            l = f_dates[1].length
            e = 1
            f_dates[1].each { |d|
              r += RiCal::FastDateTime.from_date_time(d.to_datetime).ical_str
              r += '/' if i == 0
              r += ',' if (e < l) && (i != 0)
              i += 1
              e += 1
            }
          elsif f_dates[0] == :dates
          r += ":"
            l = f_dates[1].length
            e = 1
            f_dates[1].each {|d|
              r += "#{RiCal::FastDateTime.from_date_time(d.to_datetime).ical_str}"
              r += "," if (e < l)
              e += 1
            }
          end
        elsif dates.is_a?(Date) || dates.is_a?(DateTime)
          r += ":#{RiCal::FastDateTime.from_date_time(dates.to_datetime).ical_str}"
        end
        r
      end

      protected
      @@rule = nil

        # The BYSECOND attr could be eg: 14 or multiple: 14, 45 between 0 and 59 ( i assume )
        # The BYMINUTE attr could be eg: 14 or multiple: 14, 45 between 0 and 59 ( i assume )
        # The BYSECOND attr could be eg: 14 or multiple: 14, 22 between 0 and 23 ( i assume )
        # The BYDAY attribute allows you to specify exactly which days (SA, SU, MO, TU, WE, TH, FR)
        # The BYMONTH is any month value between 1 .. 12
        # the BYMONTHDAY is any value between 1 and 31
        # WKST is the week starting on BYDAY eg SU,MO,TU,WE,TH

        #args.each {|a| args[a[0]] = a[1].to_s.upcase if (a[1].is_a? String) || (a[1].is_a? Symbol)}


      def rule(repeats, args = {})
        args[:rule] == :r ? @@rule = "RRULE" : @@rule = "EXRULE"
        @@rule += ":FREQ=#{repeats.to_s.upcase}"
        interval(args)
        args.each { |ar|
          unless [:rule, :by_set_pos, :by_week_at, :count, :occurrences, :until, :ends_at, :repeats_every, :interval].include? ar[0]
            @@rule += ";#{ar[0].to_s.gsub('_', '').upcase}=#{by_unit(ar[0], ar[1])}"
          end
        }
        @@rule += ";BYSETPOS=#{args[:by_set_pos]}" if args[:by_set_pos]
        @@rule += ";WKST=#{args[:by_week_st]}" if args[:by_week_st]
        ending(args)
        @@rule
      end

      def by_unit(measure, units)
        ms       = {:by_second    => [60, get_num, BY_N_SECONDS],
                    :by_minute    => [60, get_num, BY_N_MINUTES],
                    :by_hour      => [23, get_num, BY_N_HOURS],
                    :by_day       => [7, get_day_num, BY_DAYS],
                    :by_month_day => [31, get_day_num, BY_N_MONTH_DAYS],
                    :by_year_day  => [366, get_day_num, BY_N_YEAR_DAYS],
                    :by_week      => [52, get_num, BY_N_WEEKS],
                    :by_month     => [12, get_month_num, BY_N_MONTHS]}

        @measure = ms[measure]

        r        = ""
        d        = get_unit_nums(units)
        comp     = d.uniq.compact
        c        = comp.count
        z        = 0
        comp.each { |i|
          z += 1
          r += @measure[2][i].to_s
          r += "," unless z == c
        }
        r
      end

      def get_unit_nums(units)
        r = []
        # consts DAYS, BY_DAY
        if units.is_a? Array
          units.each { |d|
            r << @measure[1].call(d)
          }
        else
          r << @measure[1].call(units)
        end
        r
      end

      def get_num
        ->(num){
        num.to_i.modulo(@measure[0]) unless num.is_a? Symbol;
        }
      end

      def get_day_num
        ->(day){
        if DAYS.include?(day.to_s.capitalize)
          DAYS.find_index(day.to_s.capitalize)
        elsif BY_DAYS.include?(day.to_s.upcase)
          BY_DAYS.find_index(day.to_s.upcase)
        else
          day.to_i.modulo(7) unless day.is_a? Symbol
        end;
        }
      end

      def get_month_num
        ->(mon){
        if MONTHS.include?(mon.to_s.capitalize)
          MONTHS.find_index(mon.to_s.capitalize)
        elsif BY_N_MONTHS.include?(mon.to_s.upcase)
          BY_N_MONTHS.find_index(mon.to_s.upcase)
        else
          mon.to_i.modulo(12) unless mon.is_a? Symbol
        end;
        }
      end

      def interval(args)
        if args[:repeats_every]
          @@rule += ";INTERVAL=#{args[:repeats_every]}"
        elsif args[:interval]
          @@rule += ";INTERVAL=#{args[:interval]}"
        end
      end

      def ending(args)
        if args[:count]
          @@rule += ";COUNT=#{args[:count]}"
        elsif args[:occurrences]
          @@rule += ";COUNT=#{args[:occurrences]}"
        elsif args[:until]
          @@rule += ";UNTIL=#{RiCal::FastDateTime.from_date_time(args[:until].to_datetime).ical_str}"
        elsif args[:ends_at]
          @@rule += ";UNTIL=#{RiCal::FastDateTime.from_date_time(args[:ends_at].to_datetime).ical_str}"
        end
      end

    end

    module ClassMethods
      def acts_as_recurring
        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def initialize
        @rrules  ||= []
        @exrules ||= []
        @rdates  ||= []
        @exdates ||= []
        super
      end

      def recurs
        r = @rrules
        r.concat @exrules
        r.concat @rdates
        r.concat @exdates
        r.join
      end

      def add_rrule(repeats, args = {})
        rrule = Parser.rrule(repeats, args)
        @rrules << rrule
        rrule
      end

      def add_exrule(repeats, args = {})
        exrule = Parser.exrule(repeats, args)
        @exrules << exrule
        exrule
      end

      def add_rdate(args = {})
        rdate = Parser.rdate(args)
        @rdates << rdate
        rdate
      end

      def add_exdate(args = {})
        exdate = Parser.exdate(args)
        @exdates << exdate
        exdate
      end

      protected
      attr_accessor :rrules, :exrules, :rdates, :exdates
    end


  end


end
ActiveRecord::Base.send(:include, Recurs::Parser) if defined? Rails