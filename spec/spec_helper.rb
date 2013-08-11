$:.unshift File.expand_path('../lib', __FILE__)

require 'rspec'
require 'sqlite3'

require 'microscope'

# Require our macros and extensions
Dir[File.expand_path('../../spec/support/macros/*.rb', __FILE__)].map(&method(:require))

RSpec.configure do |config|
  # Include our macros
  config.include DatabaseMacros
  config.include ModelMacros

  config.before(:each) do
    # Create the SQLite database
    setup_database
  end

  config.after(:each) do
    # Make sure we remove our test database file
    cleanup_database
  end
end
