require_relative 'database_adapter'

class Sqlite3Adapter < DatabaseAdapter
  def database_configuration
    {
      adapter: 'sqlite3',
      database: ':memory:'
    }
  end

  def reset_database!
    ActiveRecord::Base.connection.execute("select 'drop table ' || name || ';' from sqlite_master where type = 'table';")
  end
end
