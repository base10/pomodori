#-*- mode: ruby; x-counterpart: ../../lib/pomodori/lunga_pausa.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require "spec_helper"

describe "Pomodori::LungaPausa" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    Pomodori::Configuration.any_instance.stub(:default_config_path).and_return( test_config_path )

    @setup          = Pomodori::Setup.new
    @configuration  = @setup.configuration
    @setup.run

    @database = Pomodori::Database.new( { configuration: @configuration } )
    @database.connect
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  # TODO: Once the pausa tests are written, abstract them to a shared
  # example group
  describe "saving" do
    it "saves a valid object" do
      pausa = build(:lunga_pausa)

      expect(pausa.valid?).to be true
      expect { pausa.save }.to_not raise_error
    end

    # Initial creation needs summary, duration, kind, state, created_at
    it "expects a summary" do
      pausa = build(:lunga_pausa, summary: '')
      expect(pausa.valid?).to be false

      pausa = build(:lunga_pausa, summary: nil)
      expect(pausa.valid?).to be false
    end

    it "expects a duration" do
      pausa = build(:lunga_pausa, duration: '')
      expect(pausa.valid?).to be false
    end

    it "expects a kind" do
      pausa = build(:lunga_pausa)
      pausa.stub(:kind).and_return(nil)

      expect(pausa.valid?).to be false
    end

    it "expects a state" do
      pausa = build(:lunga_pausa, state: '')
      expect(pausa.valid?).to be false

      pausa = build(:lunga_pausa, state: nil)
      expect(pausa.valid?).to be false
    end

    it "fills in a creation date and time" do
      pausa = build(:lunga_pausa,
                                  created_at:   nil,
                                  started_at:   nil,
                                  completed_at: nil
                                )

      expect(pausa.valid?).to be true
      expect(pausa.created_at.nil?).to be false
    end
  end

  describe "initialization" do
    before(:each) do
      @pausa = Pomodori::LungaPausa.new
    end

    it "sets a kind" do
      expect(Pomodori::LungaPausa.determine_kind).to eq('lunga_pausa')
      expect(@pausa.kind).to eq('lunga_pausa')
    end

    it "sets a state" do
      expect(@pausa.state).not_to be_nil
      expect(@pausa.state).to eq('ready')
    end

    describe "duration" do
      it "sets a default duration from config" do
        expect(@pausa.duration).not_to be_nil
        expect(@pausa.duration).to eq(15)
      end

      # TODO: CLI provided duration
    end

    describe "summary" do
      it "sets a default summary from config" do
        expect(@pausa.summary).not_to be_nil
        expect(@pausa.summary).to include("Taking a long")
      end

      # TODO: CLI provided summary
    end
  end

  describe "starting a break" do
    # Pending
  end

  describe "marking a break complete" do
    # Pending
  end

  describe "marking a break incomplete" do
    # Pending
  end

  # TODO: Testing of business logic/workflow
  # TODO: Test for failure without a config
end
