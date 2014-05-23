module Microscope
  module Utils
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
