module Microscope
  class InstanceMethod
    class BooleanInstanceMethod < InstanceMethod
      def apply
        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method 'mark_as_#{field.name}!' do
            mark_as_#{field.name}
            save!
          end

          define_method 'mark_as_not_#{field.name}!' do
            mark_as_not_#{field.name}
            save!
          end
          alias_method 'mark_as_un#{field.name}!', 'mark_as_not_#{field.name}!'

          define_method 'mark_as_#{field.name}' do
            send("#{field.name}=", true)
          end

          define_method 'mark_as_not_#{field.name}' do
            send("#{field.name}=", false)
          end
          alias_method 'mark_as_un#{field.name}', 'mark_as_not_#{field.name}'
        RUBY
      end
    end
  end
end
