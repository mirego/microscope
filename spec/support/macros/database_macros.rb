module DatabaseMacros
  # Run migrations in the test database
  def run_migration(&block)
    # Create a new migration class
    if ActiveRecord.version >= Gem::Version.new('5.0')
      klass = Class.new(ActiveRecord::Migration[ActiveRecord.version.to_s.to_f])
    else
      klass = Class.new(ActiveRecord::Migration)
    end

    # Create a new `up` that executes the argument
    klass.send(:define_method, :up) { instance_exec(&block) }

    # Create a new instance of it and execute its `up` method
    klass.new.up
  end

  def setup_database(opts = {})
    adapter = "#{opts[:adapter].capitalize}Adapter".constantize.new(database: opts[:database])
    adapter.establish_connection!
    adapter.reset_database!

    # Silence everything
    ActiveRecord::Base.logger = ActiveRecord::Migration.verbose = false
  end
end
