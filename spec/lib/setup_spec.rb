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

#   describe "write config file" do
#     it "creates the config file if it doesn't exist" do
#       pending
#     end
# 
#     it "respects an existing config file" do
#       pending
#     end
#   end

  # Find database state
  # Create the database
  # Run database migrations
end
