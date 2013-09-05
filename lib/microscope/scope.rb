module Microscope
  class Scope < Struct.new(:model, :field)
    def initialize(*args)
      super

      @field_name = field.name
      @table_name = model.name.tableize
    end

    def quoted_field
      @quoted_field ||= "#{ActiveRecord::Base.connection.quote_table_name(@table_name)}.#{ActiveRecord::Base.connection.quote_column_name(@field_name)}"
    end

    def cropped_field
      @cropped_field ||= @field_name.gsub(@cropped_field_regex, '')
    end

    # Inject ActiveRecord scopes into a model
    def self.inject_scopes(model, fields, options = {})
      fields.each do |field|
        scope = "#{field.type.to_s.camelize}Scope"

        if Microscope::Scope.const_defined?(scope)
          "Microscope::Scope::#{scope}".constantize.new(model, field).apply
        end
      end
    end
  end
end
