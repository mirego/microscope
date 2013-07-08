require "microscope/version"

require 'active_record'
require 'active_support'

require "microscope/mixin"

module Microscope
  def self.inject_into_active_record
    @inject_into_active_record ||= Proc.new do
      def self.acts_as_microscope(options = {})
        self.microscope_options = options
        self.send :include, Microscope::Mixin
      end

      def self.microscope_options=(options)
        @microscope_options = options
      end
    end
  end
end

require 'microscope/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
