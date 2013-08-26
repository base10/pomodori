require "spec_helper"

describe "Pomodori::Pomodoro" do
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

  # TODO: Once the Pomodoro tests are written, abstract them to a shared
  # example group
  describe "saving" do
    it "saves a valid object" do
      pomodoro = build(:pomodoro, config: @config)

      expect(pomodoro.valid?).to be_true
      expect { pomodoro.save }.to_not raise_error
    end

    # Initial creation needs summary, duration, kind, state, created_at
    it "expects a summary" do
      pomodoro = build(:pomodoro, config: @config, summary: '')
      expect(pomodoro.valid?).to be_false

      pomodoro = build(:pomodoro, config: @config, summary: nil)
      expect(pomodoro.valid?).to be_false
    end

    it "expects a duration" do
      pomodoro = build(:pomodoro, config: @config, duration: '')
      expect(pomodoro.valid?).to be_false
    end

    it "expects a kind" do
      pomodoro = build(:pomodoro, config: @config)
      pomodoro.stub(:kind).and_return(nil)

      expect(pomodoro.valid?).to be_false
    end

    it "expects a state" do
      pomodoro = build(:pomodoro, config: @config, state: '')
      expect(pomodoro.valid?).to be_false
      
      pomodoro = build(:pomodoro, config: @config, state: nil)
      expect(pomodoro.valid?).to be_false
    end

    it "fills in a creation date and time" do
      pomodoro = build(:pomodoro, config:       @config,
                                  created_at:   nil,
                                  started_at:   nil,
                                  completed_at: nil
                                )

      expect(pomodoro.valid?).to be_true
      expect(pomodoro.created_at.nil?).to be_false
    end
  end

  describe "initialization" do
    before(:each) do
      @pomo = Pomodori::Pomodoro.new
    end

    it "sets a kind" do
      expect(@pomo.kind).not_to be_nil
      expect(@pomo.determine_kind).to eq('pomodoro')
      expect(@pomo.kind).to eq('pomodoro')
    end

    it "sets a state" do
      expect(@pomo.state).not_to be_nil
      expect(@pomo.state).to eq('new')
    end

    describe "duration" do 
      it "sets a default duration from config" do
        expect(@pomo.duration).not_to be_nil
        expect(@pomo.duration).to eq(25)
      end

      # TODO: CLI provided duration
    end

    describe "summary" do
      it "sets a default summary from config" do
        expect(@pomo.summary).not_to be_nil
        expect(@pomo.summary).to include("Working on")
      end

      # TODO: CLI provided summary
    end
  end

  describe "starting a pomodoro" do
    # Pending
  end

  describe "marking a pomodoro complete" do
    # Pending
  end

  describe "marking a pomodoro incomplete" do
    # Pending  
  end

  # TODO: Testing of business logic/workflow
  # TODO: Test for failure without a config
end
