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
  end
end
