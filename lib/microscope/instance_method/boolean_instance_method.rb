module Microscope
  class InstanceMethod
    class BooleanInstanceMethod < InstanceMethod
      def apply
        infinitive_verb = Microscope::Utils.past_participle_to_infinitive(field.name)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{infinitive_verb}!" do
            send("#{field.name}=", true)
            save!
          end
          alias_method 'mark_as_#{field.name}!', '#{infinitive_verb}!'

          define_method "not_#{infinitive_verb}!" do
            send("#{field.name}=", false)
            save!
          end
          alias_method 'un#{infinitive_verb}!', 'not_#{infinitive_verb}!'
          alias_method 'mark_as_un#{field.name}!', 'not_#{infinitive_verb}!'
          alias_method 'mark_as_not_#{field.name}!', 'not_#{infinitive_verb}!'

          define_method "mark_as_#{field.name}" do
            send("#{field.name}=", true)
          end

          define_method "mark_as_not_#{field.name}" do
            send("#{field.name}=", false)
          end
          alias_method 'mark_as_un#{field.name}', 'mark_as_not_#{field.name}'
        RUBY
      end
    end
  end
end
