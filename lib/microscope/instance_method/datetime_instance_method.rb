module Microscope
  class InstanceMethod
    class DatetimeInstanceMethod < InstanceMethod
      def apply
        cropped_field = field.name.gsub(/_at$/, '')
        infinitive_verb = self.class.past_participle_to_infinitive(cropped_field)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{cropped_field}?" do
            value = send("#{field.name}")
            !value.nil? && value <= Time.now
          end

          define_method "not_#{cropped_field}?" do
            !#{cropped_field}?
          end

          define_method "#{infinitive_verb}!" do
            send("#{field.name}=", Time.now)
            save!
          end
        RUBY
      end
    end
  end
end
