#-*- mode: ruby; x-counterpart: ../../lib/pomodori/database.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require "spec_helper"

describe Pomodori::Database do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }
  let ( :setup )            { Pomodori::Setup.new }
  let ( :configuration )    { setup.configuration }
  let ( :database )         { Pomodori::Database.new( configuration: configuration ) }

  before(:each) do
    allow( setup ).to receive(:default_config_path).and_return( test_config_path )

    setup.ensure_config_path_exists
    setup.ensure_config_file_exists

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
    ENV['POMODORI_ENV'] = 'test'
  end

  describe "configuration" do
    it "has a configuration" do
      expect(database.configuration).to_not be(nil)
    end
  end

  describe "databases by environment" do
    describe "known environments" do
      ['test', 'development', 'production'].each do |env|
        before(:each) do
          ENV['POMODORI_ENV'] = env
        end

        it "knows where the #{env} database_file is" do
          expect(database.database_file).to_not be(nil)
        end
      end
    end
  end

  describe "connection" do
    it "connects to a database" do
      expect { database.connect }.to_not raise_error
      expect(database.db_handle).to be_a_kind_of(Sequel::SQLite::Database)
    end
  end
end
