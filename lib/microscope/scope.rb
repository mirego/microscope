module Microscope
  class Scope
    attr_reader :model, :field

    def initialize(model, field)
      @model = model
      @field = field
    end

    def quoted_field
      @quoted_field ||= "#{ActiveRecord::Base.connection.quote_table_name(@model.table_name)}.#{ActiveRecord::Base.connection.quote_column_name(@field.name)}"
    end

    def cropped_field
      @cropped_field ||= @field.name.gsub(@cropped_field_regex, '')
    end

    # Inject ActiveRecord scopes into a model
    def self.inject_scopes(model, fields, _options)
      fields.each do |field|
        scope = "#{field.type.to_s.camelize}Scope"
        "Microscope::Scope::#{scope}".constantize.new(model, field).apply if const_defined?(scope)
      end
    end

  protected

    def blacklisted_fields
      return [] unless defined? ActiveRecord::AttributeMethods::BLACKLISTED_CLASS_METHODS

      ActiveRecord::AttributeMethods::BLACKLISTED_CLASS_METHODS
    end

    def validate_field_name!(cropped_field_name, field_name)
      raise Microscope::BlacklistedColumnsError, Microscope::BlacklistedColumnsErrorMessage % field_name if blacklisted_fields.include?(cropped_field_name)
    end
  end
end
