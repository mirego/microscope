module Microscope
  class InstanceMethod < Struct.new(:model, :field)
    # Inject ActiveRecord scopes into a model
    def self.inject_instance_methods(model, fields, options = {})
      fields.each do |field|
        scope = "#{field.type.to_s.camelize}InstanceMethod"

        if Microscope::InstanceMethod.const_defined?(scope)
          "Microscope::InstanceMethod::#{scope}".constantize.new(model, field).apply
        end
      end
    end

    # Convert a past participle to its infinitive form
    def self.past_participle_to_infinitive(key)
      *key, participle = key.split('_')

      infinitive = if Microscope.irregular_verbs.include?(participle)
        Microscope.irregular_verbs[participle]
      elsif participle =~ /ed$/
        participle.sub(/d$/, '')
      else
        participle
      end

      (key << infinitive).join('_')
    end

    # Convert a value to its boolean representation
    def self.value_to_boolean(value)
      ![nil, false, 0, '0', 'f', 'F', 'false', 'FALSE'].include?(value.presence)
    end
  end
end
