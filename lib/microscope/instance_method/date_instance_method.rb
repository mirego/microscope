module Microscope
  class InstanceMethod
    class DateInstanceMethod < InstanceMethod
      def apply
        cropped_field = field.name.gsub(/_at$/, '')

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{cropped_field}?" do
            value = send("#{field.name}")
            !value.nil? && value <= Date.today
          end
        RUBY
      end
    end
  end
end
