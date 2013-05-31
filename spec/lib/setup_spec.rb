require "spec_helper"
require 'fileutils'

describe Pomodori::Setup do
  describe "data directory setup" do
    before(:each) do
      @setup = Pomodori::Setup.new
      allow(@setup).to receive(:default_config_path).and_return( 
                            File.expand_path( "../../dotpomodori", __FILE__ )  
                          )
    end

    it "creates the .pomodori folder if it doesn't exist" do
      expect { @setup.ensure_config_path_exists }.to_not raise_error
      expect( File.directory?( @setup.default_config_path ) ).to be(true)
    end

    after(:each) do
      FileUtils.rm_rf @setup.default_config_path
    end
  end

  describe "write config file" do
  end

  # Find database state
  # Create the database
  # Run database migrations

end
