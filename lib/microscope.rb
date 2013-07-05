require "microscope/version"

module Microscope
  def self.inject_into_active_record
    @inject_into_active_record ||= Proc.new do
      def self.acts_as_microscope
        self.send :include, Microscope::Mixin
      end
    end
  end
end

require 'microscope/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
