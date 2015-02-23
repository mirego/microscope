module Microscope
  class InstanceMethod
    attr_reader :model, :field

    def initialize(model, field)
      @model = model
      @field = field
    end

    def cropped_field
      @cropped_field ||= @field.name.gsub(@cropped_field_regex, '')
    end

    # Inject ActiveRecord scopes into a model
    def self.inject_instance_methods(model, fields, _options)
      fields.each do |field|
        scope = "#{field.type.to_s.camelize}InstanceMethod"
        "Microscope::InstanceMethod::#{scope}".constantize.new(model, field).apply if const_defined?(scope)
      end
    end
  end
end
