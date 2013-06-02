require 'sequel'
require 'sqlite3'

module Pomodori
  class Database
    include Pomodori::Config

    attr_accessor :db_handle

    def database_file
      db_file = default_config_path + "/" + config['database']['file']
      db_file
    end

    def ensure_database_exists
      unless File.exists?( database_file )
        @db_handle = SQLite3::Database.new database_file
      end
    end

    def setup_database_schema
      create_table_schema_migrations
    end

    def create_table_schema_migrations
      @db_handle = Sequel.connect("sqlite:///#{database_file}")
      @db_handle.run("create table schema_migrations ( version integer )")
      @db_handle.run("insert into schema_migrations values ( '1' )")
    end
  end
end
