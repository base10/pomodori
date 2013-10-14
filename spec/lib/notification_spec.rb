require "spec_helper"

describe "Pomodori::Notification" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    @setup.run
    @database = Pomodori::Database.new
    @database.connect

    @config = @database.config
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end


end
