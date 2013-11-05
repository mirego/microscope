require "microscope/version"

require 'active_record'
require 'active_support'

require "microscope/scope"
require "microscope/scope/boolean_scope"
require "microscope/scope/datetime_scope"
require "microscope/scope/date_scope"

require "microscope/instance_method"
require "microscope/instance_method/boolean_instance_method"
require "microscope/instance_method/datetime_instance_method"
require "microscope/instance_method/date_instance_method"

module Microscope
  PAST_PARTICIPLES_EXCEPTIONS = {
    'sent' => 'send',
    'taken' => 'take'
  }

  def self.past_participle_exceptions
    @past_participle_exceptions ||= PAST_PARTICIPLES_EXCEPTIONS
  end
end

class ActiveRecord::Base
  def self.acts_as_microscope(options = {})
    return unless table_exists?

    except = options[:except] || []
    model_columns = columns.dup.reject { |c| except.include?(c.name.to_sym) }

    if only = options[:only]
      model_columns = model_columns.select { |c| only.include?(c.name.to_sym) }
    end

    Microscope::Scope.inject_scopes(self, model_columns, options)
    Microscope::InstanceMethod.inject_instance_methods(self, model_columns, options)
  end
end
