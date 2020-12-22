require_relative 'database_adapter'

class InvalidAdapter < DatabaseAdapter
  def database_configuration
    {
      adapter: 'postgresql',
    }
  end

  def reset_database!
  end
end
