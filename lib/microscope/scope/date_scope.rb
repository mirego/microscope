module Microscope
  class Scope
    class DateScope < DatetimeScope
      def initialize(*args)
        super

        @now = 'Date.today'
        @now_suffix = '_today'
        @specific_suffix = '_on'
        @cropped_field_regex = /_on$/
        @formatted_time = 'time.try(:strftime, \'%Y-%m-%d\')'
      end
    end
  end
end
