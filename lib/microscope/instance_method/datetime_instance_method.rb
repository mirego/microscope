module Microscope
  class InstanceMethod
    class DatetimeInstanceMethod < InstanceMethod
      def initialize(*args)
        super

        @now = 'Time.now'
        @cropped_field_regex = /_at$/
      end

      def apply
        @cropped_field = field.name.gsub(@cropped_field_regex, '')

        model.class_eval(apply_methods) if @field.name =~ @cropped_field_regex
      end

    protected

      def apply_methods
        apply_assignment_methods + apply_bang_methods + apply_predicate_methods + apply_aliases
      end

      def apply_assignment_methods
        <<-RUBY
          define_method '#{@cropped_field}=' do |value|
            if Microscope::Utils.value_to_boolean(value)
              self.#{field.name} ||= #{@now}
            else
              self.#{field.name} = nil
            end
          end

          define_method('mark_as_#{@cropped_field}') { self.#{@cropped_field}= true }
          define_method('mark_as_not_#{@cropped_field}') { self.#{@cropped_field}= false }
          RUBY
      end

      def apply_bang_methods
        <<-RUBY
          define_method 'mark_as_#{@cropped_field}!' do
            mark_as_#{@cropped_field}
            save!
          end

          define_method 'mark_as_not_#{@cropped_field}!' do
            mark_as_not_#{@cropped_field}
            save!
          end
        RUBY
      end

      def apply_predicate_methods
        <<-RUBY
          define_method '#{@cropped_field}?' do
            value = send('#{field.name}')
            !value.nil? && value <= #{@now}
          end

          define_method('not_#{@cropped_field}?') { !#{@cropped_field}? }
        RUBY
      end

      def apply_aliases
        <<-RUBY
          alias_method 'mark_as_un#{@cropped_field}!', 'mark_as_not_#{@cropped_field}!'
          alias_method 'mark_as_un#{@cropped_field}', 'mark_as_not_#{@cropped_field}'
          alias_method 'un#{@cropped_field}?', 'not_#{@cropped_field}?'
        RUBY
      end
    end
  end
end
