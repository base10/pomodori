#-*- mode: ruby; x-counterpart: ../../../lib/pomodori/notifier/osx.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require "spec_helper"

describe "Pomodori::Notifier::Osx" do
  let ( :test_config_path ) { File.expand_path( "../../../dotpomodori", __FILE__ ) }
  let ( :output )           { double('output').as_null_object }

  before(:each) do
    Pomodori::Configuration.any_instance.stub(:default_config_path).and_return( test_config_path )

    @setup          = Pomodori::Setup.new
    @configuration  = @setup.configuration
    @setup.run

    @database = Pomodori::Database.new( { configuration: @configuration } )
    @database.connect

    Pomodori::Pomodoro.any_instance.stub(:id).and_return( 23 )
    Pomodori::Pomodoro.any_instance.stub(:pk).and_return( 23 )
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "instantiation" do
    it "expects a notification object" do
      options = { output: output  }

      expect { Pomodori::Notifier::Osx.new( options ) }.to raise_error(Pomodori::Notifier::Error)
    end
  end

  describe "delivery" do
    it "outputs information by type" do
      notification  = FactoryGirl.build(:note_start)

      TerminalNotifier.should_receive(:notify)

      notifier = Pomodori::Notifier::Osx.new( { notification: notification } )
      notifier.deliver
    end
  end
end
