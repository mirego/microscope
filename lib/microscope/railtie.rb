require 'microscope'
require 'rails'

module Microscope
  class Railtie < Rails::Railtie
    initializer 'microscope.active_record' do |app|
      ActiveSupport.on_load :active_record, {}, &Microscope.inject_into_active_record
    end
  end
end
