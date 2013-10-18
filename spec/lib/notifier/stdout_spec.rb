require "spec_helper"

describe "Pomodori::Notifier::Stdout" do
  let ( :test_config_path ) { File.expand_path( "../../../dotpomodori", __FILE__ ) }
  let ( :output )           { double('output').as_null_object }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    Pomodori::Pomodoro.any_instance.stub(:id).and_return( 23 )
    Pomodori::Pomodoro.any_instance.stub(:pk).and_return( 23 )

    @setup.run
    @database = Pomodori::Database.new
    @database.connect
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "instantiation" do
    it "expects a notification object" do
      options = { output: output  }

      expect { Pomodori::Notifier::Stdout.new( options ) }.to raise_error(Pomodori::Notifier::Error)
    end
  end

  describe "delivery" do

    it "outputs information by type" do
      options = { output: output  }


    end
  end
end
