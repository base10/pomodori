require "spec_helper"

describe Pomodori::Setup do
  describe "data directory setup" do
    before(:each) do
      @setup = Pomodori::Setup.new
      #@setup.stub().and_return(File.expand_path( "../../dotpomodori", __FILE__ )

    end

    it "creates the .pomodori folder if it doesn't exist" do
      pending
    end

    after(:each) do
      # TODO: Remove the dotpomodori directory
    end
  end

  describe "write config file" do
  end

  describe "config" do
    before(:each) do
      Pomodori::Database.any_instance.stub(:default_config_file).and_return( File.expand_path("../../config/pomodori_test.yml", __FILE__ ))
    end
  end
end
