module Microscope
  class InstanceMethod < Struct.new(:model, :field)
    def initialize(*args)
      super
      @field_name = field.name
    end

    def cropped_field
      @cropped_field ||= @field_name.gsub(@cropped_field_regex, '')
    end

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

      infinitive = if Microscope.special_verbs.include?(participle)
        Microscope.special_verbs[participle]
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
