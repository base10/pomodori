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
  end
end
