require "microscope/version"

require 'active_record'
require 'active_support'

require "microscope/scope"
require "microscope/scope/boolean_scope"
require "microscope/scope/datetime_scope"
require "microscope/scope/date_scope"

module Microscope
  def self.inject_into_active_record
    Proc.new do
      def self.acts_as_microscope(options = {})
        Microscope::Scope.inject_scopes(self, options)
      end
    end
  end
end

ActiveRecord::Base.class_eval(&Microscope.inject_into_active_record)
