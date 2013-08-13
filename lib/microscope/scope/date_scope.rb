module Microscope
  class Scope
    class DateScope < DatetimeScope
      def initialize(*args)
        super

        @now = 'Date.today'
        @now_suffix = '_today'
        @cropped_field_regex = /_on$/
      end
    end
  end
end
