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
        "Microscope::InstanceMethod::#{scope}".constantize.new(model, field).apply if const_defined?(scope)
      end
    end
  end
end
