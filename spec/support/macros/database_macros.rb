module DatabaseMacros
  # Run migrations in the test database
  def run_migration(&block)
    # Create a new migration class
    klass = Class.new(ActiveRecord::Migration)

    # Create a new `up` that executes the argument
    klass.send(:define_method, :up) { self.instance_exec(&block) }

    # Create a new instance of it and execute its `up` method
    klass.new.up
  end

  def self.database_file
    @database_file || File.expand_path('../test.db', __FILE__)
  end

  def setup_database
    # Make sure the test database file is gone
    cleanup_database

    # Establish the connection
    SQLite3::Database.new FileUtils.touch(DatabaseMacros.database_file).first
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: DatabaseMacros.database_file)

    # Silence everything
    ActiveRecord::Base.logger = ActiveRecord::Migration.verbose = false
  end

  def cleanup_database
    FileUtils.rm(DatabaseMacros.database_file) if File.exists?(DatabaseMacros.database_file)
  end
end
