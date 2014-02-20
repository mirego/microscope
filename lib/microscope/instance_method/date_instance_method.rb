module Microscope
  class InstanceMethod
    class DateInstanceMethod < InstanceMethod
      def initialize(*args)
        super

        @now = 'Date.today'
        @cropped_field_regex = /_on$/
      end

      def apply
        return unless @field_name =~ @cropped_field_regex

        cropped_field = field.name.gsub(@cropped_field_regex, '')
        infinitive_verb = self.class.past_participle_to_infinitive(cropped_field)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{cropped_field}?" do
            value = send("#{field.name}")
            !value.nil? && value <= #{@now}
          end

          define_method "#{cropped_field}=" do |value|
            if Microscope::InstanceMethod.value_to_boolean(value)
              self.#{field.name} ||= #{@now}
            else
              self.#{field.name} = nil
            end
          end

          define_method "not_#{cropped_field}?" do
            !#{cropped_field}?
          end

          define_method "#{infinitive_verb}!" do
            send("#{field.name}=", #{@now})
            save!
          end

          define_method "not_#{infinitive_verb}!" do
            send("#{field.name}=", nil)
            save!
          end
          alias_method 'un#{infinitive_verb}!', 'not_#{infinitive_verb}!'
        RUBY
      end
    end
  end
end
