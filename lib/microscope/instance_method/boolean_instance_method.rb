module Microscope
  class InstanceMethod
    class BooleanInstanceMethod < InstanceMethod
      def apply
        infinitive_verb = self.class.past_participle_to_infinitive(field.name)

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          define_method "#{infinitive_verb}!" do
            send("#{field.name}=", true)
            save!
          end

          define_method "not_#{infinitive_verb}!" do
            send("#{field.name}=", false)
            save!
          end
          alias_method 'un#{infinitive_verb}!', 'not_#{infinitive_verb}!'
        RUBY
      end
    end
  end
end
