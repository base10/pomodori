require "spec_helper"

describe Pomodori::Database do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    @setup.ensure_config_path_exists
    @setup.ensure_config_file_exists

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )
    @database = Pomodori::Database.new
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "config" do
    it "has a config" do
      expect(@database.config).to_not be(nil)
    end
  end

  describe "database file by environment" do 
    it "finds a database file by environment variable" do
      pending
    end
  end

  describe "connection" do
    it "connects to a database" do
      expect { @database.connect }.to_not raise_error
      expect(@database.db_handle).to be_a_kind_of(Sequel::SQLite::Database)
    end
  end
end
