require "spec_helper"
require 'fileutils'

describe Pomodori::Setup do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "data directory setup" do
    it "creates the .pomodori folder if it doesn't exist" do
      expect { @setup.ensure_config_path_exists }.to_not raise_error
      expect( File.directory?( @setup.default_config_path ) ).to be(true)
    end
  end

  describe "config file handling" do
    before(:each) do
      @setup.ensure_config_path_exists
    end

    context "write config file" do
      it "creates the config file if it doesn't exist" do
        expect { @setup.ensure_config_file_exists }.to_not raise_error
        expect( File.exists?( @setup.default_config_file ) ).to be(true)
      end
    end

    context "don't overwrite existing config" do
      before (:each) do 
        @setup.ensure_config_file_exists
      end

      it "respects an existing config file" do
        expect(FileUtils).to receive(:cp).with(@setup.initial_config_file).exactly(0).times
        @setup.ensure_config_file_exists
      end
    end
  end

  describe "database" do
    before(:each) do
      @setup.ensure_config_path_exists
      @setup.ensure_config_file_exists

      Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )
    end

    describe "new database" do
      it "creates a new database if one doesn't exist" do
        expect { @setup.ensure_database_exists }.to_not raise_error
        expect( File.exists?( 
                      @setup.default_config_path + "/" + @setup.config['database']['file'] 
                    ) ).to be(true)
      end

      it "creates the database structure" do
        expect { @setup.setup_database_schema }.to_not raise_error
        # TODO: Add a test to validate that schema migrations have run
      end
    end
  end
end
