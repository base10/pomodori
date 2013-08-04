require "spec_helper"

describe "Pomodori::Pomodoro" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    @setup.run

    # TODO: see if I can setup a Sequel::Model.db call here and get the model 
    # to work. As if I had to call Sequel.connect or something before I even
    # opened an object

    @database = Pomodori::Database.new
    @database.connect

    @config = @database.config    
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "saving" do
    
    it "saves a valid object" do
      pomodoro = build(:pomodoro, config: @config)
      expect(pomodoro.valid?).to be_true

      #expect { pomodoro.save }.to_not raise_error
    end
  end

  # TODO: Test for failure without a config
end
