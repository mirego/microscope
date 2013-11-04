module Microscope
  class InstanceMethod
    class DateInstanceMethod < InstanceMethod
      def apply
        cropped_field = field.name.gsub(/_on$/, '')
        infinitive_verb = self.class.past_participle_to_infinitive(cropped_field)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{cropped_field}?" do
            value = send("#{field.name}")
            !value.nil? && value <= Date.today
          end

          define_method "not_#{cropped_field}?" do
            !#{cropped_field}?
          end

          define_method "#{infinitive_verb}!" do
            send("#{field.name}=", Date.today)
            save!
          end
        RUBY
      end
    end
  end
end
