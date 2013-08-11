module Microscope
  class Scope < Struct.new(:model, :field)
    # Inject ActiveRecord scopes into a model
    def self.inject_scopes(model, options)
      except = options[:except] || []
      model_columns = model.columns.dup.reject { |c| except.include?(c.name.to_sym) }

      if only = options[:only]
        model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
      end

      model_columns.each do |field|
        scope = "#{field.type.to_s.camelize}Scope"

        if Microscope::Scope.const_defined?(scope)
          "Microscope::Scope::#{scope}".constantize.new(model, field).apply
        end
      end
    end
  end
end
