require "microscope/version"

require 'active_record'
require 'active_support'

require "microscope/mixin"

module Microscope
  def self.inject_into_active_record
    @inject_into_active_record ||= Proc.new do
      def self.acts_as_microscope(options = {})
        @microscope_options = options
        include Microscope::Mixin
      end
    end
  end
end

ActiveRecord::Base.class_eval(&Microscope.inject_into_active_record)
