require "microscope/version"

require 'active_record'
require 'active_support'

require "microscope/scope"
require "microscope/scope/boolean_scope"
require "microscope/scope/datetime_scope"
require "microscope/scope/date_scope"

require "microscope/instance_method"
require "microscope/instance_method/datetime_instance_method"
require "microscope/instance_method/date_instance_method"

module Microscope
  def self.inject_into_active_record
    Proc.new do
      def self.acts_as_microscope(options = {})
        except = options[:except] || []
        model_columns = columns.dup.reject { |c| except.include?(c.name.to_sym) }

        if only = options[:only]
          model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
        end

        Microscope::Scope.inject_scopes(self, model_columns, options)
        Microscope::InstanceMethod.inject_instance_methods(self, model_columns, options)
      end
    end
  end
end

ActiveRecord::Base.class_eval(&Microscope.inject_into_active_record)
