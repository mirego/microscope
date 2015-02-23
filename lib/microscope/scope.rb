module Microscope
  class Scope
    attr_reader :model, :field

    def initialize(model:, field:)
      @model = model
      @field = field
    end

    def quoted_field
      @quoted_field ||= "#{ActiveRecord::Base.connection.quote_table_name(@model.name.tableize)}.#{ActiveRecord::Base.connection.quote_column_name(@field.name)}"
    end

    def cropped_field
      @cropped_field ||= @field.name.gsub(@cropped_field_regex, '')
    end

    # Inject ActiveRecord scopes into a model
    def self.inject_scopes(model, fields, _options)
      fields.each do |field|
        scope = "#{field.type.to_s.camelize}Scope"
        "Microscope::Scope::#{scope}".constantize.new(model: model, field: field).apply if const_defined?(scope)
      end
    end
  end
end
