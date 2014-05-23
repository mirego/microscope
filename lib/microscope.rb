require 'microscope/version'

require 'ostruct'
require 'active_record'
require 'active_support'

require 'microscope/utils'

require 'microscope/scope'
require 'microscope/scope/boolean_scope'
require 'microscope/scope/datetime_scope'
require 'microscope/scope/date_scope'

require 'microscope/instance_method'
require 'microscope/instance_method/boolean_instance_method'
require 'microscope/instance_method/datetime_instance_method'
require 'microscope/instance_method/date_instance_method'

module Microscope
  IRREGULAR_VERBS_FILE = File.expand_path('../../data/irregular_verbs.yml', __FILE__)

  def self.special_verbs
    irregular_verbs_from_yaml ||= YAML.load_file(IRREGULAR_VERBS_FILE)
    special_verbs_from_configuration ||= configuration.special_verbs

    @special_verbs ||= begin
      irregular_verbs_from_yaml.merge(special_verbs_from_configuration)
    end
  end

  def self.configure
    @configuration = configuration
    yield(@configuration)
  end

  def self.configuration
    @configuration ||= OpenStruct.new(special_verbs: {})
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
