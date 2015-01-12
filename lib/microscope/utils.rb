module Microscope
  module Utils
    # Convert a value to its boolean representation
    def self.value_to_boolean(value)
      ![nil, false, 0, '0', 'f', 'F', 'false', 'FALSE'].include?(value.presence)
    end
  end
end
