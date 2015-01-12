$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

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

  # Disable `should` syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :each do
    # Establish ActiveRecord database connection
    adapter = ENV['DB_ADAPTER'] || 'sqlite3'
    setup_database(adapter: adapter, database: 'microscope_test')
  end
end
