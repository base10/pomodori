require 'sequel'
require 'fileutils'
require 'pp'

module Pomodori
  class Database
    Sequel.extension :migration

    attr_accessor :db_handle

    def database_file
      unless known_environments.member?(environment)
        raise Exception, "Improper environment. Must be in #{known_environments.flatten}"
      end

      db_file = default_config_path + "/" + config['database']["#{environment}"]
      db_file
    end

    def connect
      @db_handle = Sequel.connect("sqlite:///#{database_file}")
    end

    def migrations_path
      migrations = File.expand_path( "../../../config/migrations", __FILE__ )
      migrations
    end

    def ensure_database_exists
#       unless File.exists?( database_file )
#         puts "I'm ensuring a database!"
#
#         begin
#           @db_handle = SQLite3::Database.new database_file
#         rescue SQLite3::CantOpenException => e
#           pp e
#           puts database_file
#
#           raise e
#         end
#
#       else
#         puts "No database needed!"
#       end

      unless File.exists?( database_file )
        begin
          FileUtils.touch database_file
        rescue Errno::ENOENT => e
          pp e
          raise e
        end

        connect
      end
    end

    def run_migrations
      Sequel::Migrator.run( connect, migrations_path, :use_transactions => true )
    end
  end
end
