module Microscope
  class InstanceMethod
    class DateInstanceMethod < DatetimeInstanceMethod
      def initialize(*args)
        super

        @now = 'Date.today'
        @cropped_field_regex = /_on$/
      end
    end
  end
end
