#-*- mode: ruby; x-counterpart: ../../spec/lib/database_spec.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require 'sequel'
require 'fileutils'
require 'pp'

module Pomodori
  class Database
    Sequel.extension :migration

    attr_accessor :db_handle, :configuration

    def initialize( params )
      @configuration = params.fetch(:configuration)
    end

    def database_file
      configuration.database_file
    end

    def connect
      @db_handle = Sequel.connect("sqlite:///#{database_file}")
    end

    # FIXME: Let configuration handle this
    def migrations_path
      migrations = File.expand_path( "../../../config/migrations", __FILE__ )
      migrations
    end

    def ensure_database_exists
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
