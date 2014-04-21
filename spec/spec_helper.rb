$:.unshift File.expand_path('../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'sqlite3'
require 'mysql2'
require 'pg'

require 'microscope'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/**/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|
  # Include our macros
  config.include DatabaseMacros
  config.include ModelMacros

  config.before :each do
    # Establish ActiveRecord database connection
    adapter = ENV['DB_ADAPTER'] || 'sqlite3'
    setup_database(adapter: adapter, database: 'microscope_test')

    # Reset internal variables
    Microscope.instance_variable_set(:@configuration, nil)
    Microscope.instance_variable_set(:@special_verbs, nil)
  end
end
